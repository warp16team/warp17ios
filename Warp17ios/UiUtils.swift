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
