//
//  ViewController.swift
//  Warp17ios
//
//  Created by Mac on 10.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import UIKit

class PlanetsViewController: UITableViewController {
    
    var dataStorage: DataStorage {
        get {
            return DataStorage.sharedInstance
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        AppSettings.sharedInstance.setRealmIsInitialized(state: false)
        
        dataStorage.planetsVC = self
        dataStorage.refreshViewControllers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStorage.planets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planetCell", for: indexPath)
        
        cell.textLabel?.text = dataStorage.planets[indexPath.row].name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "planetCities" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! CitiesViewController
                destinationVC.planetId = dataStorage.planets[indexPath.row].id
            }
            
        }
    }
}

