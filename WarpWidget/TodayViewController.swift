//
//  TodayViewController.swift
//  WarpWidget
//
//  Created by Mac on 01.09.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var label: UILabel!
    
    @IBAction func goToMainApp(_ sender: Any) {
        extensionContext?.open(URL(string: "warpExtension://more")!, completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let defaults = UserDefaults(suiteName: "group.warp17Game") {
            print("viewDidload - read user default success")
        
            if let content = defaults.string(forKey: "labelContents") {
                label.text = content
            }
        }
        // defaults?.set(DataStorage.sharedDataStorage.getCurrentCity().name, forKey: "labelContents")
        /*let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.warp17Game")
        var content: String = ""
        
        do {
            try content = try String(contentsOf: url!, encoding: .utf8)
        } catch let error as Error {
            print(error)
        }
 */
        
    }
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("widgetPerformUpdate")
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        guard let defaults = UserDefaults(suiteName: "group.warp17Game") else {
            print("widgetPerformUpdate - cannot read suite")

            completionHandler(NCUpdateResult.failed)
            return
        }
        
        if let content = defaults.value(forKey: "labelContents") as? String {
            label.text = content
            
            print("widgetPerformUpdate - new data")
            completionHandler(NCUpdateResult.newData)
        } else {
            
            print("widgetPerformUpdate - no data")
            completionHandler(NCUpdateResult.noData)
            
        }
    }
    
}
