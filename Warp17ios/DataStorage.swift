//
//  DataStorage.swift
//  Warp17ios
//
//  Created by Mac on 15.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import RealmSwift

private let _sharedDataStorage = DataStorage()

// var semaphore = DispatchSemaphore(value: 0) // создаем семафор
//let playGrp = DispatchGroup() // создаем группу
//let queue = DispatchQueue(label: "com.dispatchgroup", attributes: .initiallyInactive, target: .main)
//var item: DispatchWorkItem? // создаем блок

let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)
//let serialQueue = DispatchQueue(label: "serial_queue")

protocol TableViewRefreshDelegate {
    func reloadTableViewData();
}

class DataStorage {
    
    class var sharedDataStorage: DataStorage {
        return _sharedDataStorage
    }
    //    --------------------------------------------
    public var citiesById: [Int: RealmCity] = [:]
    //private var _cities: [RealmCity] = []
    //
    //public var cities: [RealmCity] {
    //    var citiesCopy: [RealmCity]!
    //    concurrentQueue.sync {
    //        citiesCopy = self._cities
    //    }
    //    return citiesCopy
    //}
    //    --------------------------------------------
    

    public var planets: [RealmPlanet] = []
    public var citiesIdsByPlanetId: [Int: [Int]] = [:]
    
    private var citiesVC: TableViewRefreshDelegate? = nil
    private var planetsVC: TableViewRefreshDelegate? = nil
    
    private var citiesProvider = CitiesProvider()
    private let realm = try! Realm()
    
    public var currentPlanetId: Int = 0
    public var currentCityId: Int = 0
    
    init()
    {
                //let defaults = UserDefaults(suiteName: "group.warpGame")
                
                // defaults?.set(string: self.getCurrentCity().name, forKey: "labelContents")
        
        //let defaults = UserDefaults(suiteName: "group.warpGame")
        
        if AppSettings.sharedInstance.checkIsRealmInitialized() {
            UiUtils.debugPrint("data storage", "realm is not empty")
            
            loadDataFromDb()
        }
    }
    
    public func setPlanetsVC(_ VC: TableViewRefreshDelegate) {
        planetsVC = VC
    }
    
    public func setCitiesVC(_ VC: TableViewRefreshDelegate) {
        citiesVC = VC
    }
    
    public func getCurrentCity() -> RealmCity
    {
        return citiesById[currentCityId]!
    }
    
    public func loadDataFromDb() {
        UiUtils.debugPrint("data storage", "loading data from db")
        
        loadCitiesDataFromDb()
        loadPlanetsDataFromDb()
        
        refreshViewControllers()
    }
    
    public func loadDataFromApi() {
        UiUtils.debugPrint("data storage", "loading data from api")
        citiesProvider.loadJson()
    }
    
    public func refreshViewControllers() {
        UiUtils.debugPrint("data storage", "refreshing table views")

        if planetsVC != nil {
            planetsVC!.reloadTableViewData()
        }
        
        if citiesVC != nil {
            citiesVC!.reloadTableViewData()
        }
    }
    
    private func loadCitiesDataFromDb() {
        citiesById.removeAll(keepingCapacity: true)
        citiesIdsByPlanetId.removeAll(keepingCapacity: true)
        
        for city in realm.objects(RealmCity.self) {
            citiesById[city.id] = city
            let planetId = city.planet!.id
            if citiesIdsByPlanetId[planetId] == nil {
                citiesIdsByPlanetId[planetId] = [city.id]
            } else {
                citiesIdsByPlanetId[(city.planet?.id)!]?.append(city.id)
            }
        }
    }
    
    private func loadPlanetsDataFromDb() {
        planets = []
        
        for planet in realm.objects(RealmPlanet.self) {
            planets.append(planet)
        }
    }
    
    public func getCitiesForPlanet(planetId: Int) -> [RealmCity] {
        var result: [RealmCity] = []
        
        let citiesIdsOfPlanet = citiesIdsByPlanetId[planetId] ?? []
        
        for cityId in citiesIdsOfPlanet {
            result.append(citiesById[cityId]!)
        }
        
        return result
    }
}
