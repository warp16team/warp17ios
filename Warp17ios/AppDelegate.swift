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
        
        //let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil)
        //UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(
            UIApplicationBackgroundFetchIntervalMinimum)
        
        let wm = WatchManager()
        wm.sendText(String(describing: Date()))
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.scheme == "warpgame" {
            NSLog("\(url)")
            
            // TODO : do something with the URL
            
            return true //let iOS know we handled it
        }
        
        return false
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
    
    //var semaphore = DispatchSemaphore(value: 0)
    //var timerTest: Timer? = nil
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    //    semaphore = DispatchSemaphore(value: 0)
        
        UiUtils.debugPrint("background fetch", "started at \(Date())")
        
        let lastSync = AppSettings.sharedInstance.getLastSyncAt()
        
        if lastSync != nil && abs(lastSync!.timeIntervalSinceNow) < 30 {
            UiUtils.debugPrint("background fetch", "sync time < 30 sec ago -> .noData")
            completionHandler(.noData)
            return
        }
        
        let updater = EventsUpdater()
        updater.proceed()
        
  //      timerTest = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        /*
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
        
        DispatchQueue.main.sync {
            timer.resume()
            
        }
        UiUtils.debugPrint("background fetch", "timer resume called")
        */
        /*repeat {
            DispatchQueue.main.async {
                sleep(1)
                UiUtils.debugPrint("background fetch", "--after 1 seconds")
            }
            if EventsUpdater.shared.eventsFetchComplete {
                UiUtils.debugPrint("background fetch", "eventsFetchComplete!!")
                UiUtils.debugPrint("background fetch", "return .newData")
                completionHandler(.newData)
            }
        } while (true)
*/
        /*let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            UiUtils.debugPrint("background fetch", "after 2 seconds")
        }
        RunLoop.current.add(timer, forMode: .commonModes)
        */
        //let timeout = DispatchTime.now() + .seconds(29)
       /* if semaphore.wait(timeout: timeout) == .timedOut {
            
            UiUtils.debugPrint("background fetch", "TIMEOUT - return .failed")
            completionHandler(.failed)
            timerTest?.invalidate()
            timerTest = nil
            return
        }
         */
        //UiUtils.debugPrint("background fetch", "TIMEOUT - return .failed")
        //completionHandler(.failed)
        UiUtils.debugPrint("background fetch", "return .newData")
        completionHandler(.newData)
       // timerTest?.invalidate()
        //timerTest = nil
        return
    }
    
    /*func onTimer()
    {
        UiUtils.debugPrint("background fetch", "timer tick")
        
        if EventsUpdater.shared.eventsFetchComplete {
            UiUtils.debugPrint("background fetch", "timer tick - eventsFetchComplete")
            semaphore.signal()
        }
    }*/
}

