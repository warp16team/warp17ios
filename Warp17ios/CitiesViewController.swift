//
//  ViewController.swift
//  Warp17ios
//
//  Created by Mac on 10.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import UIKit

class CitiesViewController: UITableViewController {
    
    var dataStorage: DataStorage {
        get {
            return DataStorage.sharedInstance
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataStorage.citiesVC = self
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
        return dataStorage.cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        cell.textLabel?.text = dataStorage.cities[indexPath.row].name
        
        return cell
    }
}

