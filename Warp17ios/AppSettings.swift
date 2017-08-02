//
//  FirstRunChecker.swift
//  Warp17ios
//
//  Created by Mac on 17.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation

class AppSettings {
    public static let sharedInstance: AppSettings = AppSettings()
    
    private let keyRealmInitialized = "realmInitialized"
    private let keyAppId = "appId"
    private var isRealmInitialized: Bool?
    private var appId: String?
    
    public func checkIsRealmInitialized() -> Bool {
        if isRealmInitialized == nil {
            isRealmInitialized = UserDefaults.standard.object(forKey: keyRealmInitialized) as! Bool?
        }
        
        if isRealmInitialized == nil {
            isRealmInitialized = false
        }
        
        print("realm initialized is \(isRealmInitialized!)")
        return isRealmInitialized!
    }
    
    public func setRealmIsInitialized(state: Bool = true) {
        UserDefaults.standard.set(state, forKey: keyRealmInitialized)
        UserDefaults.standard.synchronize()
        print("set realm initialized = \(state)")
        isRealmInitialized = state
    }
    
    public func hasAppId() -> Bool
    {
        return getAppId() != nil
    }
    
    public func getAppId() -> String? {
        if appId == nil {
            appId = UserDefaults.standard.object(forKey: keyAppId) as! String?
        }
        
        return appId
    }
    
    public func setAppId(appId value: String) {
        appId = value
        UserDefaults.standard.set(appId, forKey: keyAppId)
        UserDefaults.standard.synchronize()
    }
}
