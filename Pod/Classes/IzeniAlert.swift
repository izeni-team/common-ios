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
    :param: data: The data passed into the IzeniAlert Object
    :param: actionIdentifier: the identifier of the action tapped
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
    let data: [String:AnyObject]
    let action: String
    let title: String
    var soundName = UILocalNotificationDefaultSoundName
    static var delegate: IzeniAlertDelegate!
    private static let IzeniAlertID = NSUUID()
    var customizations = IZNotificationCustomizations()
    
    init(data: [String:AnyObject], title: String, action: String) {
        self.data = data
        self.title = title
        self.action = action
    }
    /**
    Displays the IZNotification or UILocalNotification, depending on applicationState.
    */
    public func show() {
        let app = UIApplication.sharedApplication()
        if app.applicationState == .Background {
            let notification = UILocalNotification()
            notification.userInfo = [
                "IzeniAlertID": IzeniAlert.IzeniAlertID,
                "data": data,
            ]
            notification.alertBody = title
            notification.alertAction = action
            notification.soundName = soundName
            app.presentLocalNotificationNow(notification)
        } else {
            IZNotification.show(title, duration: 3, withCollapseDuplicates: true, customization: customizations, onTap: { () -> Void in
                IzeniAlert.delegate.alertHandled(self.data)
            })
        }
    }
    
    class func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if let userInfo = notification.userInfo where userInfo["IzeniAlertID"] as? NSUUID == IzeniAlertID {
            IzeniAlert.delegate.alertHandled(notification.userInfo!["data"] as! [String:AnyObject])
        }
    }
}