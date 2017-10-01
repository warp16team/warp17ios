//
//  NotificationEvent.swift
//  Warp17ios
//
//  Created by Mac on 03.08.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation

enum NotificationEvent: String
{
    case applicationRegistered = "applicationRegistered"
    case readyToAuth = "readyToAuth"
    case authenticated = "authenticated"
    case gpsUpdated = "gpsUpdated"
    case newGameEvent = "newGameEvent"
    case possibleBuildingsLoaded = "possibleBuildingsLoaded"
    
}
