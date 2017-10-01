//
//  RealmCityBuildingProvider.swift
//  Warp17ios
//
//  Created by Mac on 27.09.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCityBuildingProvider
{
    var vcDelegate: CityBuildingsDelegate
    let realm = try! Realm()
    var dataLoaded = false
    
    fileprivate var container: [Int:[Int: RealmCityBuilding]] = [:]
    
    init(_ vcDelegate: CityBuildingsDelegate)
    {
        UiUtils.debugPrint("RealmCityBuildingProvider", "init")
        self.vcDelegate = vcDelegate
        loadFromDb()
    }
    
    public func getForCity(cityId: Int) -> [Int:RealmCityBuilding]
    {
        return container[cityId] ?? [:]
    }
    
    public func loadFromDb() {
        UiUtils.debugPrint("RealmCityBuildingProvider", "load from db")
        UiUtils.debugPrint("RealmCityBuildingProvider", "load from db, starting with main sync...")
        
            
        UiUtils.debugPrint("RealmCityBuildingProvider", "load from db")
        self.container = [:]
        UiUtils.debugPrint("RealmCityBuildingProvider", "get realm objects RealmCityBuilding")
            
        for cityBuilding in self.realm.objects(RealmCityBuilding.self) {
            UiUtils.debugPrint("RealmCityBuildingProvider", "set cityBuilding")
            UiUtils.debugPrint("RealmCityBuildingProvider", "\(cityBuilding.city!.id)")
            UiUtils.debugPrint("RealmCityBuildingProvider", "\(cityBuilding.id)")
                self.container[cityBuilding.city!.id]?[cityBuilding.id] = cityBuilding
        }
        UiUtils.debugPrint("RealmCityBuildingProvider", "container: \(self.container)")
        
        UiUtils.debugPrint("RealmCityBuildingProvider", "set buildings for vc, city: \(self.vcDelegate.getCityId())")
        
        let buildings = Array(self.getForCity(cityId: self.vcDelegate.getCityId()).values)
        
        UiUtils.debugPrint("RealmCityBuildingProvider", "count \(buildings.count)")
        
        self.vcDelegate.setBuildingsAndReload(buildings: buildings)
        UiUtils.debugPrint("RealmCityBuildingProvider", "done")
       
    }
}

protocol CityBuildingsSynchronizationProtocol {
    func sync(newData: [RealmCityBuilding], cityId: Int);
}

extension RealmCityBuildingProvider: CityBuildingsSynchronizationProtocol
{
    public func sync(newData: [RealmCityBuilding], cityId: Int)
    {
        UiUtils.debugPrint("RealmCityBuildingProvider sync", "started for city: \(cityId)")
        UiUtils.debugPrint("RealmCityBuildingProvider sync", "new data count = \(newData.count)")
        
        var currentData = getForCity(cityId: cityId)
        UiUtils.debugPrint("RealmCityBuildingProvider sync", "current city results count = \(currentData.count)")
        var newDataDict = sortById(cityBuildings: newData)
        
        // delete wrong elements
        for (key, item) in currentData {
            if newDataDict[key] == nil {
                UiUtils.debugPrint("RealmCityBuildingProvider sync", "realm delete item, id=\(item.id)")
                try! realm.write {
                    realm.delete(item)
                }
                currentData.removeValue(forKey: item.id)
            }
        }
        
        // add new elements
        for (key, item) in newDataDict {
            if currentData[key] == nil {
                UiUtils.debugPrint("RealmCityBuildingProvider sync", "realm add item, id=\(item.id)")
                try! realm.write {
                    realm.add(item, update: true)
                }
                currentData[item.id] = item
            }
        }
        
        container[cityId] = currentData
        
        UiUtils.debugPrint("RealmCityBuildingProvider sync", "calling setBuildingsAndReload - vc cityId = \(vcDelegate.getCityId())")
        let buildings = Array(getForCity(cityId: vcDelegate.getCityId()).values)
        UiUtils.debugPrint("RealmCityBuildingProvider sync", "count buildings: \(buildings.count)")
            
        vcDelegate.setBuildingsAndReload(buildings: buildings)
    }
    
    fileprivate func sortById(cityBuildings:[RealmCityBuilding]) -> [Int:RealmCityBuilding]
    {
        var results: [Int:RealmCityBuilding] = [:]
        
        for cityBuilding in cityBuildings {
            results[cityBuilding.id] = cityBuilding
        }
        
        return results
    }
}


