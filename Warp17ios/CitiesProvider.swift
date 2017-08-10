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

class CitiesProvider
{
    typealias planetsDict = [Int:RealmPlanet]
    
    private let realm = try! Realm()
    private var dataStorage: DataStorage {
        get {
            return DataStorage.sharedDataStorage
        }
    }
    
    func loadJson() {
        print("\(Thread.current) - cities provider: loadJson")
        
        let client = ApiClient()
        
        client.request(endpoint: "/cities", parameters: Parameters()) { json in
            
            print("\(Thread.current) - cities provider: proceedWithJSON")
            
            DispatchQueue.main.async {
                print("\(Thread.current) - cities provider: save data to realm")
                
                print(self.realm.configuration.fileURL!)
                
                let planets = self.savePlanets(json: json["planets"])
                self.saveCities(json: json["cities"], planetsDict: planets)
                
                AppSettings.sharedInstance.setRealmIsInitialized()
                
                print("\(Thread.current) - cities provider: data to realm saved")
                
                self.dataStorage.loadDataFromDb()
            }            
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
        
        return planets
    }
    
    func saveCities(json: JSON, planetsDict: planetsDict) {
        for (_, subJson) in json {
            let city = RealmCity()
            city.id = subJson["id"].intValue
            city.name = subJson["name"].stringValue
            city.population = subJson["population"].intValue
            city.planet = planetsDict[subJson["planetId"].intValue]!
            
            try! realm.write {
                realm.add(city, update: true)
            }
        }
    }
}
