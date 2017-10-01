//
//  CityBuildingsViewController.swift
//  Warp17ios
//
//  Created by Mac on 13.09.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol CityBuildingsDelegate
{
    func setBuildingsAndReload(buildings: [RealmCityBuilding]);
    func getCityId() -> Int;
}

extension CityBuildingsViewController: CityBuildingsDelegate
{
    func setBuildingsAndReload(buildings: [RealmCityBuilding]) {
        UiUtils.debugPrint("buildings vc", "setBuildingsAndReload")
        UiUtils.debugPrint("buildings vc", "count buildings: \(buildings.count)")
        self.buildings = buildings
        
        
        UiUtils.debugPrint("buildings vs", "reload data")
        tableView.reloadData()
    }
    func getCityId() -> Int {
        return self.cityId
    }
}

class CityBuildingsViewController: UIViewController {
    var cityId:Int = 0
    var buildings: [RealmCityBuilding] = []
    var buildingsProvider:BuildingsProvider?

    let message = UNMutableNotificationContent()
    var refreshTimer: Timer?
    var completionReloadTimers: [Timer] = []
    
    public override func viewDidLoad() {    
        UiUtils.debugPrint("city buildings vc", "viewDidload")
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        cityId = DataStorage.sharedDataStorage.currentCityId
        message.badge = 0
        

        DataStorage.sharedDataStorage.cityBuildingProvider = RealmCityBuildingProvider(self)
        
        buildingsProvider = BuildingsProvider(realmStorage: DataStorage.sharedDataStorage.cityBuildingProvider!)
        buildingsProvider!.buildingsVcDelegate = self
        
        refreshData()
        
        refreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTable), userInfo: nil, repeats: true)
        
        UiUtils.debugPrint("city buildings vc", "viewDidload done")
    }
    
    func initTimers() {
        completionReloadTimers = []
        for building in buildings {
            if building.buildCompleted {
                let secondsToComplete = calcSecondsToComplete(startedAt: building.buildStartedAt!, buildTimeInMinutes: building.buildTime)
                
                let timer = Timer.scheduledTimer(timeInterval: TimeInterval(secondsToComplete), target: self, selector: #selector(refreshData), userInfo: nil, repeats: false)
                
                completionReloadTimers.append(timer)
            }
        }
    }
    
    private func calcSecondsToComplete(startedAt: Date, buildTimeInMinutes: Int) -> Int
    {
        let dtEnd:Date = (startedAt.addingTimeInterval(
            TimeInterval(buildTimeInMinutes * 60)
        ))

        let calendar = NSCalendar.current
        var compos:Set<Calendar.Component> = Set<Calendar.Component>()
        compos.insert(.second)
        let difference = calendar.dateComponents(compos, from: Date(), to: dtEnd)
        
        return difference.second!
    }
    
    func updateTable()
    {
        tableView.reloadData()
    }
    
    func refreshData() {
        
        UiUtils.debugPrint("city buildings vc", "calling getCityBuildings")
        buildingsProvider!.getCityBuildings(cityId: DataStorage.sharedDataStorage.currentCityId)
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        UiUtils.debugPrint("city buildings vc", "prepare for segue \(String(describing: segue.identifier))")
        
        if segue.identifier == "showPossibleBuildingsList" {
            if let destinationVC = segue.destination as? CityPossibleBuildingsViewController{
                destinationVC.buildings = []
                
                buildingsProvider!.getPossibleBuildings(cityId: DataStorage.sharedDataStorage.currentCityId, vc: destinationVC)
            }
            
        }
    }
    
}

extension CityBuildingsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buildingCell", for: indexPath)
        //UiUtils.debugPrint("city buildings vc", "cell \(indexPath.row)")
        let building = buildings[indexPath.row]
        cell.textLabel?.text = "\(String(describing: building.level!.name)) lv.\(String(describing: building.level!.level))"
        
        if building.buildCompleted {
            cell.detailTextLabel?.text = ""
        } else {
            //UiUtils.debugPrint("city buildings vc", "build time \(building.level!.buildTime) minutes")
            
            let dtEnd:Date = (building.buildStartedAt!.addingTimeInterval(
                TimeInterval(building.level!.buildTime * 60)
            ))
            
            //let df = DateFormatter()
            //UiUtils.debugPrint("city buildings vc", "build ends at \(dtEnd) -> \(df.string(from: dtEnd))")


//            let df = DateFormatter()
//            let ti = TimeInterval()
            let calendar = NSCalendar.current
            var compos:Set<Calendar.Component> = Set<Calendar.Component>()
            compos.insert(.second)
            compos.insert(.minute)
            let difference = calendar.dateComponents(compos, from: Date(), to: dtEnd)
            
            //UiUtils.debugPrint("city buildings vc", "diff in minute=\(difference.minute!)")
            //UiUtils.debugPrint("city buildings vc", "diff in seconds=\(difference.second!)")
            
            //            let interval = Int(dtEnd.timeIntervalSince(Date()))
            
            cell.detailTextLabel?.text =
                String(difference.minute!) + " min "
                + String(difference.second!) + " sec remaining"
        }
        
        
        return cell
    }
}

extension CityBuildingsViewController: UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        UiUtils.debugPrint("city buildings vc - numberOfRowsInSection", "count buildings: \(buildings.count)")

        return buildings.count
    }}
