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

// глобальное todo: токен может истекать и тогда надо запрашивать новый
// ловим ошибку с определенным кодом - имплементировать в API

class AuthProvider
{
    func fetchToken() {
        print("\(Thread.current) - auth provider: calling endpoint...")
        var params: Parameters = [:]
        params["appId"] = AppSettings.sharedInstance.getAppId()
        
        let client = ApiClient()
        
        client.request(endpoint: "/auth", parameters: params, method: .post) { json in
            
            print(json)
            
            print("\(Thread.current) - auth provider: success, got token")
            ApiClient.token = json["token"].stringValue
            
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: String(describing: NotificationEvent.authenticated)),
                object: nil
            )            
        }
    }
}
