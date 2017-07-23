//
//  CitiesProvider.swift
//  Warp17ios
//
//  Created by Mac on 13.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class UpdatesProvider: ApiClient {
    var endpoint = "/content"
    
    private var dataStorage: DataStorage {
        get {
            return DataStorage.sharedInstance
        }
    }
    
    func loadJson() {
        request(endpoint: endpoint, parameters: Parameters())
    }
    
    override func proceedWithJSON(json: JSON) {
        print(json)
        
        Updater.proceedSync(files: json["files"])
        
        print("updates: finished loading data fron json")
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
            print(city)
            
            try! realm.write {
                realm.add(city, update: true)
            }
        }
    }
}
