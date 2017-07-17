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
    private var isRealmInitialized: Bool?
    
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
}
