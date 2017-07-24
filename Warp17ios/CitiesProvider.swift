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
        request(endpoint: endpoint, parameters: Parameters())
    }
    
    override func proceedWithJSON(json: JSON) {
        // print(json)
        
        print(realm.configuration.fileURL!)
        
        let planets = savePlanets(json: json["planets"])
        saveCities(json: json["cities"], planetsDict: planets)
        AppSettings.sharedInstance.setRealmIsInitialized()
        
        print("finished loading data fron json")
        
        dataStorage.loadDataFromDb()
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
