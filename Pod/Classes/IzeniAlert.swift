//
//  IzeniAlert.swift
//  IzeniAlert
//
//  Created by Skyler Smith on 7/17/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import UIKit

/**
protocol IzeniAlertDelegate: class

The IzeniAlertDelegate will receive calls to alertHandled when the user taps an action on an IzeniAlert.
*/
public protocol IzeniAlertDelegate: class {
    /**
    - parameter data:: The data passed into the IzeniAlert Object
    - parameter actionIdentifier:: the identifier of the action tapped
    */
    func alertHandled(data: [String:AnyObject])
}

/**
class IzeniAlert: NSObject

A custom user notification Object that will display IZNotifications if the application is active or UILocalNotifications if it is inactive.

The AppDelegate must implement didRecieveLocalNotification in the appDelegate like this:

func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
IzeniAlert.application(application, didReceiveLocalNotification: notification)
}
*/
public class IzeniAlert: NSObject {
    public static var soundName = UILocalNotificationDefaultSoundName
    public static var delegate: IzeniAlertDelegate!
    private static let IzeniAlertID = "64a9c192-62e6-48fc-8fae-a6af68f77015"
    public static var collapseDuplicates = false
    
    /**
    Displays the IZNotification or UILocalNotification, depending on applicationState.
    */
    public static func show(title: String, action: String, data: [String:AnyObject], delegate: IzeniAlertDelegate, customizations: IZNotificationCustomizations?) {
        
        self.delegate = delegate
        
        let app = UIApplication.sharedApplication()
        
        if app.applicationState == .Background {
            let notification = UILocalNotification()
            notification.userInfo = [
                "IzeniAlertID": IzeniAlert.IzeniAlertID,
                "data": data
            ]
            notification.alertBody = title
            notification.alertAction = action
            notification.soundName = soundName
            app.presentLocalNotificationNow(notification)
        } else {
            IZNotification.show(title, duration: 3, collapseDuplicates: false, customization: customizations ?? IZNotificationCustomizations(), onTap: { () -> Void in
                IzeniAlert.delegate.alertHandled(data)
            })
        }
    }
    
    public class func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if let userInfo = notification.userInfo where userInfo["IzeniAlertID"] as? String == IzeniAlertID {
            IzeniAlert.delegate.alertHandled(notification.userInfo!["data"] as! [String:AnyObject])
        }
    }
}