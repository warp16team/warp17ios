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
        extensionContext?.open(URL(string: "warpteam.Warp17ios://more")!, completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.warpGame")
        var content: String = ""
        
        do {
            try content = try String(contentsOf: url!, encoding: .utf8)
        } catch let error as Error {
            print(error)
        }
        
        label.text = content
        
    }
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
