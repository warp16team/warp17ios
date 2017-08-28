//
//  EventsUpdater.swift
//  Warp17ios
//
//  Created by Mac on 28.08.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import UIKit

private let _sharedEventsUpdater = EventsUpdater()

class EventsUpdater
{
    class var shared: EventsUpdater {
        return _sharedEventsUpdater
    }

    public var events: [GameEvent] = []
    public var eventsFetchInProgress = false
    public var eventsFetchComplete = false

    public func proceed() -> UIBackgroundFetchResult {
        
        guard eventsFetchInProgress == false else {
            UiUtils.debugPrint("events updater", "events update is in progress")
            return UIBackgroundFetchResult.failed
        }
        
        events = []
        eventsFetchInProgress = true
        eventsFetchComplete = false
        
        let provider = EventsProvider()
        provider.fetchEvents()
        
        
        // WAIT FOR DATA
        
        return UIBackgroundFetchResult.failed
    }
}
