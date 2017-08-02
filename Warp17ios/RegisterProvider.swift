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

class RegisterProvider: ApiClient {
    var endpoint = "/register"
    
    func createAppId() {
        print("\(Thread.current) - register provider: calling endpoint...")
        request(endpoint: endpoint, parameters: Parameters())
    }
    
    override func proceedWithJSON(json: JSON) {
        print(json)
        AppSettings.sharedInstance.setAppId(appId: json["appId"].stringValue)
        
        print("\(Thread.current) - register provider: success, ready to auth")
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: String(describing: NotificationEvent.readyToAuth)),
            object: nil
        )
    }
}
