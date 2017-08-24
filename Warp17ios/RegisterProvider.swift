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

class RegisterProvider
{
    func createAppId() {
        UiUtils.debugPrint("register provider", "calling endpoint...")
        
        let client = ApiClient()
        
        client.request(endpoint: "/register", parameters: Parameters()) { json in
            
            print(json)
            AppSettings.sharedInstance.setAppId(appId: json["appId"].stringValue)
            
            UiUtils.debugPrint("register provider", "success, ready to auth")
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: String(describing: NotificationEvent.readyToAuth)),
                object: nil
            )
        }
    }
}
