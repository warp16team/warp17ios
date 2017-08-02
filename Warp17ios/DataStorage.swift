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


class DataStorage {
    
    class var sharedDataStorage: DataStorage {
        return _sharedDataStorage
    }
    //    --------------------------------------------
    public var cities: [RealmCity] = []
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
    
    public var citiesVC: CitiesViewController? = nil
    public var planetsVC: PlanetsViewController? = nil
    
    private var citiesProvider = CitiesProvider()
    private let realm = try! Realm()
    
    init()
    {
        if AppSettings.sharedInstance.checkIsRealmInitialized() {
            print("\(Thread.current) - data storage: realm is not empty")
            loadDataFromDb()
        }
    }
    
    public func loadDataFromDb() {
        print("\(Thread.current) - data storage: loading data from db")
        loadCitiesDataFromDb()
        loadPlanetsDataFromDb()
        refreshViewControllers()
    }
    
    public func loadDataFromApi() {
        print("\(Thread.current) - data storage: loading data from api")
        citiesProvider.loadJson()
    }
    
    public func refreshViewControllers() {
        print("\(Thread.current) - data storage: refreshing table views")

        if planetsVC != nil {
            planetsVC!.tableView.reloadData()
        }
        
        if citiesVC != nil {
            citiesVC!.cities = getCitiesForPlanet(planetId: citiesVC!.planetId)
            citiesVC!.tableView.reloadData()
        }
    }
    
    private func loadCitiesDataFromDb() {
        cities = []
        for city in realm.objects(RealmCity.self) {
            cities.append(city)
        }
    }
    
    private func loadPlanetsDataFromDb() {
        planets = []
        for planet in realm.objects(RealmPlanet.self) {
            planets.append(planet)
        }
    }
    
    private func getCitiesForPlanet(planetId: Int) -> [RealmCity] {
        var result: [RealmCity] = []
        
        for city in cities {
            if city.planet!.id == planetId {
                result.append(city)
            }
        }
        
        return result
    }
}
