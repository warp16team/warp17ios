//
//  RealmPlanet.swift
//
//
//  Created by Mac on 14.07.17.
//
//

import Foundation
import RealmSwift

class RealmCityBuilding: Object {
    dynamic var id: Int = 0
    dynamic var city: RealmCity?
    dynamic var level: RealmBuildingLevel?
    
    dynamic var buildTime: Int = 0
    dynamic var buildStartedAt: Date?
    dynamic var buildCompleted: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
