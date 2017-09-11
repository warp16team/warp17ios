//
//  InterfaceController.swift
//  WarpWatch Extension
//
//  Created by Mac on 08.09.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    var session: WCSession?

    @IBOutlet var textContainer: WKInterfaceLabel!
    
    @IBAction func iAmHereBtn() {
        print("i am here btn click")

        if let currentSession = session {
            currentSession.sendMessage(["iAmHere": "I am here!"], replyHandler: nil, errorHandler: {error in
                print("Send data error: \(error)")
            })
            print("message sent")
        } else {
            print("session is not started")
        }
    }
    
    override func awake(withContext context: Any?) {
        print("awake and start session")
        super.awake(withContext: context)
        
        startSession()

        // Configure interface objects here.
    }
    func startSession(){
        if WCSession.isSupported() {
            print("session started and activated ok")

            session = WCSession.default()
            session?.delegate = self
            session?.activate()
        } else {
            print("wc session is not supported")
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session error: \(error)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("message from ios received: \(message)")
        if let textValue = message["textValue"] as? String {
            textContainer.setText(textValue)
        }
    }
    
}
