//
//  AppDelegate.swift
//  IZExample
//
//  Created by Christopher Bryan Henderson on 11/12/15.
//  Copyright © 2015 Bryan Henderson. All rights reserved.
//

import UIKit
import Izeni

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, IZNotificationDelegate {

    var window: UIWindow?
    
    func notificationHandled(data: [String : AnyObject]) {
        print("handled: \(data)")
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let types: UIUserNotificationType = [.Badge, .Sound, .Alert]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)

        IZNotification.unifiedDelegate = self
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        IZNotification.application(application, didReceiveLocalNotification: notification)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "doThing", userInfo: nil, repeats: false)
        task = application.beginBackgroundTaskWithExpirationHandler { () -> Void in
            
        }
    }
    
    var task = UIBackgroundTaskInvalid

    func applicationDidEnterBackground(application: UIApplication) {

    }

    func doThing() {
        print("SHOW")
        IZNotification.showUnified("Title?", subtitle: "Subtitle?", data: ["String": "hello world"])
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

