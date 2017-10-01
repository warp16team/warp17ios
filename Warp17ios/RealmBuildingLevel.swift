//
//  RealmPlanet.swift
//
//
//  Created by Mac on 14.07.17.
//
//

import Foundation
import RealmSwift

class RealmBuildingLevel: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var level: Int = 0
    dynamic var population: Int = 0
    dynamic var buildTime: Int = 0
    dynamic var value: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
