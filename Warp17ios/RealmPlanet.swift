//
//  RealmPlanet.swift
//
//
//  Created by Mac on 14.07.17.
//
//

import Foundation
import RealmSwift

class RealmPlanet: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
