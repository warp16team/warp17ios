//
//  ViewController.swift
//  Warp17ios
//
//  Created by Mac on 10.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import UIKit

class CitiesViewController: UITableViewController {
    
    var cityList: [String] = ["MyCity1", "MyCity2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pr = CitiesProvider()
        
        pr.loadJson()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        cell.textLabel?.text = cityList[indexPath.row]
        
        return cell
    }
}

