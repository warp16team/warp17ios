//
//  ViewController.swift
//  Warp17ios
//
//  Created by Mac on 10.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import UIKit

class PlanetsViewController: UITableViewController, TableViewRefreshDelegate {
    
    var dataStorage: DataStorage {
        get {
            return DataStorage.sharedDataStorage
        }
    }
    
    let updater = Updater()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        AppSettings.sharedInstance.setRealmIsInitialized(state: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(authenticate), name: NSNotification.Name(rawValue: String(describing: NotificationEvent.readyToAuth)), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startUserApiInteraction), name: NSNotification.Name(rawValue: String(describing: NotificationEvent.authenticated)), object: nil)
        
        if !AppSettings.sharedInstance.hasAppId() {
            let registrator = RegisterProvider()
            registrator.createAppId()
        } else {
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: String(describing: NotificationEvent.readyToAuth)),
                object: nil
            )
        }
        
        dataStorage.setPlanetsVC(self)
        dataStorage.refreshViewControllers()
    }
    
    public func reloadTableViewData() {
        tableView.reloadData()
    }
    
    func authenticate()
    {
        print("\(Thread.current) - ready to auth -> authenticating...")
        
        let authenticator = AuthProvider()
        authenticator.fetchToken()
    }
    
    func startUserApiInteraction()
    {
        updater.proceed()
        tableView.reloadData()

        dataStorage.loadDataFromApi()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataStorage.planets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planetCell", for: indexPath)
        
        cell.textLabel?.text = dataStorage.planets[indexPath.row].name
        
        let imageFilename: String = "house_simple.png"
        // todo dataStorage.planets[indexPath.row].imageFilename
        
        cell.imageView?.image = UIImage(
            contentsOfFile: updater.getPathForContentFile(imageFilename)
        )
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "planetCities" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! CitiesViewController
                dataStorage.currentPlanetId = dataStorage.planets[indexPath.row].id
                //destinationVC.planetId = dataStorage.planets[indexPath.row].id
            }
            
        }
    }
}

