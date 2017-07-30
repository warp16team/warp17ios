//
//  CitiesProvider.swift
//  Warp17ios
//
//  Created by Mac on 13.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import Alamofire

class CitiesProvider: ApiClient {
    typealias planetsDict = [Int:RealmPlanet]
    
    var endpoint = "/cities"
    
    private let realm = try! Realm()
    private var dataStorage: DataStorage {
        get {
            return DataStorage.sharedInstance
        }
    }
    
    func loadJson() {
        
        print("\(Thread.current) - loadJson")
        
        NotificationCenter.default.addObserver(self, selector: #selector(downloadComplete), name: NSNotification.Name(rawValue: getNotificationName()), object: nil)
        
        request(endpoint: endpoint, parameters: Parameters())
    }
    
    @objc func downloadComplete()
    {
        print("\(Thread.current) - city api request complete - main thread actions");
        
        DispatchQueue.main.sync {
            dataStorage.loadDataFromDb()
        }
    }
    
    override func proceedWithJSON(json: JSON) {
        
        print("\(Thread.current) - proceedWithJSON")
        // print(json)
        
        DispatchQueue.main.async {
            print("\(Thread.current) - proceedWithJSON - inside main async")
            
            print(self.realm.configuration.fileURL!)
            
            let planets = self.savePlanets(json: json["planets"])
            self.saveCities(json: json["cities"], planetsDict: planets)
            AppSettings.sharedInstance.setRealmIsInitialized()
            
            print("\(Thread.current) - finished loading data fron json")
            
        }
    }
    
    func savePlanets(json: JSON) -> planetsDict {
        var planets: planetsDict = [:]
        
        for (_, subJson) in json {
            let planet = RealmPlanet()
            planet.id = subJson["id"].intValue
            planet.name = subJson["name"].stringValue
            planets[planet.id] = planet
            
            try! realm.write {
                realm.add(planet, update: true)
            }
        }
//        print(planets)
        
        return planets
    }
    
    func saveCities(json: JSON, planetsDict: planetsDict) {
        for (_, subJson) in json {
            let city = RealmCity()
            city.id = subJson["id"].intValue
            city.name = subJson["name"].stringValue
            city.population = subJson["population"].intValue
            city.planet = planetsDict[subJson["planetId"].intValue]!
            // print(city)
            
            try! realm.write {
                realm.add(city, update: true)
            }
        }
    }
}
