//
//  UiUtils.swift
//  Warp17ios
//
//  Created by Mac on 20.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import UIKit

class UiUtils {
    public static let sharedInstance: UiUtils = UiUtils()
    
    public func errorAlert(text: String, title: String = "Error") {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showAlertGlobally(alert)
    }
    
    public static func debugPrint(_ caption: String, _ text: String) {
        let currentThread = getPrettyCurrentThreadDescription()
        
        print("\(currentThread) - \(caption): \(text)")
    }
    
    
    private static func getPrettyCurrentThreadDescription() -> String {
        let raw: String = "\(Thread.current)"
        let text = getSplittedText(before: "{", after: "}", text: raw)
        let text2 = getSplittedText(before: "number = ", after: ",", text: text)
        
        let firstSplit: [String] = text.components(separatedBy: ", name = ")
        
        return text2 + "|" + firstSplit[1]
    }
    
    private static func getSplittedText(before: String, after: String, text: String) -> String
    {
        let firstSplit: [String] = text.components(separatedBy: before)
        if firstSplit.count > 1 {
            let secondSplit: [String] = firstSplit[1].components(separatedBy: after)
            if secondSplit.count > 0 {
                return secondSplit[0]
            }
        }
        
        return text
    }
//    public func showLoader() {
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//        
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        loadingIndicator.startAnimating();
//        
//        alert.view.addSubview(loadingIndicator)
////        present(alert, animated: true, completion: nil)
//    }
}
