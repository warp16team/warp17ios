//
//  DataStorage.swift
//  Warp17ios
//
//  Created by Mac on 15.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import RealmSwift

class DataStorage {
    public static let sharedInstance: DataStorage = DataStorage()

    public var cities: [RealmCity] = []
    public var planets: [RealmPlanet] = []
    
    public var citiesVC: CitiesViewController? = nil
    public var planetsVC: PlanetsViewController? = nil
    
    private var citiesProvider = CitiesProvider()
    private let realm = try! Realm()
    
    init()
    {
        if AppSettings.sharedInstance.checkIsRealmInitialized() {
            loadDataFromDb()
        }

        loadDataFromApi()
    }
    
    public func loadDataFromDb() {
        loadCitiesDataFromDb()
        loadPlanetsDataFromDb()
        refreshViewControllers()
    }
    
    public func loadDataFromApi() {
        citiesProvider.loadJson()
    }
    
    public func refreshViewControllers() {
        print("refreshing table views")

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
