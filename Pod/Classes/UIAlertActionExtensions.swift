//
//  UIAlertActionExtensions.swift
//  Izeni
//
//  Created by Christopher Bryan Henderson on 9/14/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

import UIKit

public extension UIAlertAction {
    public class func cancelAction() -> UIAlertAction {
        return UIAlertAction(title: "Cancel", callback: nil)
    }
    
    public class func cancelAction(callback: (() -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: "Cancel", callback: callback)
    }
    
    public class func okAction() -> UIAlertAction {
        return UIAlertAction(title: "OK", callback: nil)
    }
    
    public class func okAction(callback: (() -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: "OK", callback: callback)
    }
    
    public convenience init(title: String, callback: (() -> Void)?) {
        self.init(title: title, style: .default, handler: { _ in
            callback?()
        })
    }
    
    public convenience init(destructiveTitle: String, callback: (() -> Void)?) {
        self.init(title: destructiveTitle, style: .destructive, handler: { _ in
            callback?()
        })
    }
}
