//
//  GameEvent.swift
//  Warp17ios
//
//  Created by Mac on 28.08.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import SwiftyJSON

enum GameEventType: String
{
    case none = "none"
    case unknown = "unknown"
    case harvestComplete = "harvestComplete"
}

class GameEvent {
    var id: Int = 0
    var type: GameEventType = .none
    var data: [JSON] = []
    var ts: Date = Date()
}
