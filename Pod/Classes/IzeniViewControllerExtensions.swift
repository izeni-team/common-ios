//
//  IzeniViewControllerExtensions.swift
//  Alder
//
//  Created by Skyler Smith on 7/28/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     Sets up an action sheet for iPad using the direction 'up' or 'down,' depending on the space available.
    
     - parameter alert: The UIAlertController to be presented as an action sheet.
     - parameter source: The source view from which the popover will be presented.
    */
    public func setPopoverPresentation(alert: UIAlertController, source: UIView) {
        alert.popoverPresentationController?.sourceView = source
        var targetPoint = source.frame.origin
        var view = source
        while let superView = view.superview, let superSuperView = superView.superview {
            targetPoint = superSuperView.convert(targetPoint, from: superView)
            view = superView
        }
        
        if targetPoint.y > self.view.frame.height - targetPoint.y {
            alert.popoverPresentationController?.permittedArrowDirections = .down
            alert.popoverPresentationController?.sourceRect = CGRect(x: source.frame.width / 2.0, y: 0, width: 1, height: 1)
        } else {
            alert.popoverPresentationController?.permittedArrowDirections = .up
            alert.popoverPresentationController?.sourceRect = CGRect(x: source.frame.width / 2.0, y: source.frame.height, width: 1, height: 1)
        }
    }
}
