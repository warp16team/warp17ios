//
//  RealmPlanet.swift
//
//
//  Created by Mac on 14.07.17.
//
//

import Foundation
import RealmSwift

class RealmCity: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var planet: RealmPlanet?
    dynamic var population: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }

    public func getFormattedPopulation() -> String {
        switch population {
            case _ where Decimal(population) > pow(1000, 2):
                return String(Double(Int(population/1000/10))/100) + "M"
            case _ where Decimal(population) > 1000:
                return String(Double(Int(population/10))/100) + "K"
            default:
                return String(population)
        }
    }
}
