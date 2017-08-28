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
    private let keyLastSyncAt = "lastSyncAt"
    private var isRealmInitialized: Bool?
    private var appId: String?
    private var lastSyncAt: Date?
    
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
    
    public func getLastSyncAt() -> Date? {
        if lastSyncAt == nil {
            lastSyncAt = UserDefaults.standard.object(forKey: keyLastSyncAt) as! Date?
        }
        
        return lastSyncAt
    }
    
    public func setLastSyncAt(newSyncAt value: Date) {
        lastSyncAt = value
        UserDefaults.standard.set(lastSyncAt, forKey: keyLastSyncAt)
        UserDefaults.standard.synchronize()
    }
}
