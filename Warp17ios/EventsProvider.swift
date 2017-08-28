//
//  RegisterProvider.swift
//  Warp17ios
//
//  Created by Mac on 02.08.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class EventsProvider
{
    func fetchEvents() {
        UiUtils.debugPrint("events provider", "calling endpoint...")
        var params: Parameters = [:]
        
        params["lastSyncAt"] = AppSettings.sharedInstance.getLastSyncAt()
        UiUtils.debugPrint("events provider", "lastUpdatedAt = \(String(describing: params["lastSyncAt"]))")
        
        let client = ApiClient()
        
        client.request(endpoint: "/events", parameters: params, method: .get) { json in
            
            UiUtils.debugPrint("events provider", "success, got \(json["events"].arrayValue.count) events")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let events = json["events"].arrayValue
            
            for event in events {
                UiUtils.debugPrint("events provider", "received game event type=\(event["type"])")
                
                let gameEvent = GameEvent()
                gameEvent.id = event["id"].intValue
                gameEvent.data = event["data"].arrayValue
                
                gameEvent.ts = formatter.date(from: event["createdAt"].stringValue)!
                
                switch event["type"].stringValue {
                case "harvest_complete":
                    gameEvent.type = .harvestComplete
                default:
                    gameEvent.type = .unknown
                }
                
                EventsUpdater.shared.events.append(gameEvent)
                
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: String(describing: NotificationEvent.newGameEvent)),
                    object: nil,
                    userInfo: ["event":gameEvent]
                )
            }
            
            EventsUpdater.shared.eventsFetchComplete = true
            EventsUpdater.shared.eventsFetchInProgress = false
        }
    }
}
