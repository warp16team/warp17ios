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
        UiUtils.debugPrint("auth provider", "calling endpoint...")
        var params: Parameters = [:]
        
        params["appId"] = AppSettings.sharedInstance.getAppId()
        UiUtils.debugPrint("auth provider", "appId = \(String(describing: params["appId"]))")
        
        let client = ApiClient()
        
        client.request(endpoint: "/auth", parameters: params, method: .post) { json in
                        
            UiUtils.debugPrint("auth provider", "success, got token \(json["token"].stringValue)")
            ApiClient.token = json["token"].stringValue
            
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: String(describing: NotificationEvent.authenticated)),
                object: nil
            )            
        }
    }
}
