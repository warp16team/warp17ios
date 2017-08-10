//
//  ViewController.swift
//  Warp17ios
//
//  Created by Mac on 10.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import UIKit

class CitiesViewController: UITableViewController, TableViewRefreshDelegate {
    
    public var planetId: Int = 0
    public var cities: [RealmCity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("showing cities for planetId \(planetId)")
        
        DataStorage.sharedDataStorage.setCitiesVC(self)
        DataStorage.sharedDataStorage.refreshViewControllers()
    }
    
    public func reloadTableViewData() {
        cities = DataStorage.sharedDataStorage.getCitiesForPlanet(planetId: planetId)
        tableView.reloadData()
    }

    @IBAction func refreshDataFromApi(_ sender: Any) {
        DataStorage.sharedDataStorage.loadDataFromApi()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        cell.textLabel?.text = cities[indexPath.row].name
        cell.detailTextLabel?.text = cities[indexPath.row].getFormattedPopulation()
        
        return cell
    }
    
    @IBAction func returnToCitiesList(segue: UIStoryboardSegue) {
        
    }
}

