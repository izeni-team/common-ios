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
    func alertHandled(data: [String:AnyObject], actionIdentifier: String)
}

/**
class IzeniAlert: NSObject

A custom user notification Object that will display UIAlerts if the application is active or UILocalNotifications if it is inactive.

The AppDelegate must implement didRecieveLocalNotification in the appDelegate like this:

  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    IzeniAlert.application(application, didReceiveLocalNotification: notification)
  }
*/
public class IzeniAlert: NSObject {
    let data: [String:AnyObject]
    typealias Action = (text: String, identifier: String)
    let defaultAction: Action
    let otherActions: [Action]
    let title: String
    let message: String
    var soundName = UILocalNotificationDefaultSoundName
    var preferredStyle = UIAlertControllerStyle.Alert
    static var delegate: IzeniAlertDelegate!
    private static let IzeniAlertID = NSUUID()
    
    init(data: [String:AnyObject], title: String, message: String, defaultAction: Action, otherActions: [Action]) {
        self.data = data
        self.defaultAction = defaultAction
        self.otherActions = otherActions
        self.title = title
        self.message = message
    }
    /**
    Displays the UIAlert or UILocalNotification, depending on applicationState.
    */
    public func show() {
        let app = UIApplication.sharedApplication()
        if app.applicationState == .Background {
            let notification = UILocalNotification()
            notification.userInfo = [
                "IzeniAlertID": IzeniAlert.IzeniAlertID,
                "data": data,
                "defaultIdentifier": defaultAction.identifier
            ]
            notification.alertBody = message
            notification.alertAction = defaultAction.text
            notification.soundName = soundName
            app.presentLocalNotificationNow(notification)
        } else {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            for action in otherActions + [defaultAction] {
                alert.addAction(UIAlertAction(title: action.text, style: .Default, handler: { _ in
                    IzeniAlert.delegate.alertHandled(self.data, actionIdentifier: action.identifier)
                }))
            }
            let window = app.keyWindow!
            window.rootViewController!.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    class func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if let userInfo = notification.userInfo where userInfo["IzeniAlertID"] as? NSUUID == IzeniAlertID {
            IzeniAlert.delegate.alertHandled(notification.userInfo!["data"] as! [String:AnyObject], actionIdentifier: notification.userInfo!["defaultIdentifier"] as! String)
        }
    }
}