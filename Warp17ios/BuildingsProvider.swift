//
//  RegisterProvider.swift
//  Warp17ios
//
//  Created by Mac on 02.08.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RealmSwift

class BuildingsProvider
{
    private let realm = try! Realm()
    private var vc: CityPossibleBuildingsViewController?
    private var realmStorage: CityBuildingsSynchronizationProtocol
    
    public var buildingsVcDelegate: CityBuildingsDelegate?
    
    init(realmStorage: CityBuildingsSynchronizationProtocol) {
        UiUtils.debugPrint("BuildingsProvider", "init")
        self.realmStorage = realmStorage
    }
    
    func getPossibleBuildings(cityId: Int, vc: CityPossibleBuildingsViewController) {
        self.vc = vc
        
        UiUtils.debugPrint("buildings provider", "calling get possible buildings endpoint...")
        UiUtils.debugPrint("buildings provider", "cityId = \(String(describing: cityId))")
        
        let client = ApiClient()
        
        client.request(endpoint: "/city/\(cityId)/buildings/possible", parameters: [:], method: .get) { json in
            
            UiUtils.debugPrint("buildings provider", "success, got \(json["buildings"].arrayValue.count) buildings")
            
            self.savePossibleBuildings(json)
        }
    }
    
    private func savePossibleBuildings(_ json: JSON) {
        
        var results: [RealmBuildingLevel] = []
        
        for (_, subJson) in json["buildings"] {
            let buildingLevel = RealmBuildingLevel()
            
            buildingLevel.id = subJson["id"].intValue
            buildingLevel.level = subJson["level"].intValue
            buildingLevel.name = subJson["name"].stringValue
            buildingLevel.population = subJson["population"].intValue
            buildingLevel.buildTime = subJson["buildTime"].intValue
            buildingLevel.value = subJson["value"].intValue
            
            DispatchQueue.main.async {
                UiUtils.debugPrint("buildings provider", "writing possible building level \(buildingLevel.id)")
                

                try! self.realm.write {
                    self.realm.add(buildingLevel, update: true)
                }
            }
            
            results.append(buildingLevel)
            
            vc?.buildings = results
            vc?.tableView.reloadData()
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: String(describing: NotificationEvent.possibleBuildingsLoaded)),
            object: nil
        )
    }
    
    func startBuild(_ cityBuilding: RealmCityBuilding)
    {
        UiUtils.debugPrint("buildings provider", "calling start build endpoint...")
        
        let cityId = cityBuilding.city?.id
        
        UiUtils.debugPrint("buildings provider", "cityId = \(String(describing: cityId))")
        
        let client = ApiClient()
        
        var params: Parameters = [:]
        params["buildingId"] = cityBuilding.level?.id
        
        client.request(endpoint: "/city/" + String(cityId!) + "/buildings", parameters: params, method: .post) { json in
        
            UiUtils.debugPrint("buildings provider", "create building success, got id=\(json["building"]["id"].intValue)")
            
            self.proceedWithCreatingBuilding(cityBuilding, json)
            
        }
    }
    
    private func proceedWithCreatingBuilding(_ cityBuilding: RealmCityBuilding, _  json: JSON) {
        
        cityBuilding.id = json["building"]["id"].intValue
        
        let dateFormatter = DateFormatter()
        cityBuilding.buildStartedAt = dateFormatter.date(from: json["building"]["buildStartedAt"].stringValue)
        
        DispatchQueue.main.async {
            try! self.realm.write {
                UiUtils.debugPrint("buildings provider", "adding cityBuilding id=\(cityBuilding.id)")
                self.realm.add(cityBuilding, update: true)
            }
        }
    }
    
    func getCityBuildings(cityId: Int)
    {
        UiUtils.debugPrint("buildings provider", "calling city buildings list endpoint...")
        
        let client = ApiClient()
        
        let params: Parameters = [:]
        
        client.request(endpoint: "/city/" + String(cityId) + "/buildings", parameters: params, method: .get) { json in
            
            UiUtils.debugPrint("buildings provider: calling city buildings list", "proceed with data")
            
            DispatchQueue.main.async {
                self.proceedWithCityBuildingsList(cityId, json)
            }
        }
    }
    
    private func proceedWithCityBuildingsList(_ cityId: Int, _ json: JSON) {
        var cityBuildings = [RealmCityBuilding]()
        
        for (_, subJson) in json["buildings"] {
            let buildingLevel = RealmBuildingLevel()
            
            buildingLevel.id = subJson["buildingLevel"]["id"].intValue
            buildingLevel.level = subJson["buildingLevel"]["level"].intValue
            buildingLevel.name = subJson["buildingLevel"]["name"].stringValue
            buildingLevel.population = subJson["buildingLevel"]["population"].intValue
            buildingLevel.buildTime = subJson["buildingLevel"]["buildTime"].intValue
            buildingLevel.value = subJson["buildingLevel"]["value"].intValue
            
                try! self.realm.write {
                    UiUtils.debugPrint("buildings provider", "saving buildingLevel id=\(buildingLevel.id)")
                    self.realm.add(buildingLevel, update: true)
                }
            
            
            let cityBuilding = RealmCityBuilding()
            cityBuilding.id = subJson["id"].intValue
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxx"
            cityBuilding.buildStartedAt = df.date(from: subJson["buildStartedAt"].stringValue)
            UiUtils.debugPrint("buildings provider", " build started at \(subJson["buildStartedAt"].stringValue) -> \(cityBuilding.buildStartedAt)")
            
            cityBuilding.buildTime = subJson["buildTime"].intValue
            cityBuilding.buildCompleted = subJson["buildCompleted"].boolValue
            cityBuilding.level = buildingLevel
            cityBuilding.city = DataStorage.sharedDataStorage.citiesById[cityId]
            
                try! self.realm.write {
                    UiUtils.debugPrint("buildings provider", "saving cityBuilding id=\(cityBuilding.id)")
                    self.realm.add(cityBuilding, update: true)
                }
            
            cityBuildings.append(cityBuilding)
        }

        // apply new data to city buildings list
        if self.buildingsVcDelegate != nil {
            UiUtils.debugPrint("buildings provider", "calling vc setBuildingsAndReload")
            self.buildingsVcDelegate?.setBuildingsAndReload(buildings: cityBuildings)
        }
        
        // synchronization with local storage
        UiUtils.debugPrint("buildings provider", "proceed with sync in realmstorage")
        
            self.realmStorage.sync(newData: cityBuildings, cityId: cityId)
        
    }
    
}
