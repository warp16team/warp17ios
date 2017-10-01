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

class CityPossibleBuildingsViewController: UITableViewController {
    var buildings: [RealmBuildingLevel] = []
    
    let message = UNMutableNotificationContent()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBuilding = buildings[indexPath.row]
        
        let cityBuilding = RealmCityBuilding()
        cityBuilding.city = DataStorage.sharedDataStorage.getCurrentCity()
        cityBuilding.buildStartedAt = Date()
        cityBuilding.buildTime = selectedBuilding.buildTime
        cityBuilding.level = selectedBuilding
        
        let buildingsProvider = BuildingsProvider(realmStorage: DataStorage.sharedDataStorage.cityBuildingProvider!)
        buildingsProvider.startBuild(cityBuilding)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, error in
            if let err = error {
                print(err)
            }
            if didAllow {
                UiUtils.debugPrint("city buildings vc", "notifications permissions granted")
            }else {
                UiUtils.debugPrint("city buildings vc", "notifications permissions NOT granted")
            }
        })
        
        message.title = "\(selectedBuilding.name) lv.\(selectedBuilding.level) completed"
        message.subtitle = "Construction completed"
        message.body = "You have done construction \(selectedBuilding.name) lv.\(selectedBuilding.level)"
        message.badge = message.badge ?? 0 + 1 as NSNumber
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(60 * selectedBuilding.buildTime), repeats: false)
        let request = UNNotificationRequest(identifier: "buildingConstructionDone_NewBuilding", content: message, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
        //dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return buildings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "possibleBuildingCell", for: indexPath)
        
        cell.textLabel?.text = buildings[indexPath.row].name
        cell.detailTextLabel?.text = String(buildings[indexPath.row].buildTime) + " minute(s)"

        
        UiUtils.debugPrint("buildings", "cell: \(buildings[indexPath.row].name)")
        
        return cell
    }
    
}
