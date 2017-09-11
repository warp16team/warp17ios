//
//  WatchManager.swift
//  Warp17ios
//
//  Created by Mac on 11.09.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchManager: NSObject, WCSessionDelegate {
    
    var session: WCSession? {
        didSet {
            if let session = session {
                print("WC Session activated")
                session.delegate = self
                session.activate()
            }
        }
    }
    
    override init() {
        //super.init()
        
        if WCSession.isSupported() {
            session = WCSession.default()
            print("WC Session created")
        }
    }
    
    func sendText(_ textValue: String) {
        print("Message to watch sent!")
        if let currentSession = session {
            currentSession.sendMessage(["textValue": textValue], replyHandler: nil, errorHandler: {error in
                print("Send data error: \(error)")
            })
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("watch activationDidCompleteWith")
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("watch sessionDidBecomeInactive")
    }
    func sessionDidDeactivate(_ session: WCSession) {
        print("watch sessionDidDeactivate")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("new message \(message)")
        if let data = message["iAmHere"] as? String {
            UiUtils.sharedInstance.errorAlert(text: "Message from Apple Watch App: " + data)
        }
    }
    

}
