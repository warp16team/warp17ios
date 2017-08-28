//
//  AppDelegate.swift
//  Warp17ios
//
//  Created by Mac on 10.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(
            UIApplicationBackgroundFetchIntervalMinimum)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Utility function to avoid:
    // Warning: Attempt to present * on * whose view is not in the window hierarchy!
    func showAlertGlobally(_ alert: UIAlertController) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.windowLevel = UIWindowLevelAlert
        alertWindow.rootViewController = UIViewController()
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        UiUtils.debugPrint("background fetch", "started at \(Date())")
        
        let lastSync = AppSettings.sharedInstance.getLastSyncAt()
        
        if lastSync != nil && abs(lastSync!.timeIntervalSinceNow) < 30 {
            UiUtils.debugPrint("background fetch", "sync time < 30 sec ago -> .noData")
            completionHandler(.noData)
            return
        }
        
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer.scheduleRepeating(deadline: .now(), interval: .seconds(29), leeway: .seconds(1))
        timer.setEventHandler {
            UiUtils.debugPrint("background fetch", "time limit exceeded")
            if EventsUpdater.shared.eventsFetchComplete {
                UiUtils.debugPrint("background fetch", "return .newData")
                completionHandler(.newData)
            } else {
                UiUtils.debugPrint("background fetch", "return .failed")
                completionHandler(.failed)
            }
            
            return
        }
        timer.resume()
        
        let updater = EventsUpdater()
        updater.proceed()
        
        UiUtils.debugPrint("background fetch", "updater proceed called, return .newData")
        completionHandler(.newData)
        
        return
    }
}

