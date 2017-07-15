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
        loadDataFromDb()
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
        if planetsVC != nil {
            planetsVC!.tableView.reloadData()
        }
        if citiesVC != nil {
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
}
