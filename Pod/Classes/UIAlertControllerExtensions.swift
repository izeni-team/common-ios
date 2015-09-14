//
//  UIAlertControllerExtensions.swift
//  Izeni
//
//  Created by Christopher Bryan Henderson on 9/14/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

import UIKit

public extension UIAlertController {
    public class func presentAlertIn(viewController: UIViewController, title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        for action in actions {
            alert.addAction(action)
        }
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}