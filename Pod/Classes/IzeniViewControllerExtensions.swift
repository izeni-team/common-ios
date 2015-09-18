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
            targetPoint = superSuperView.convertPoint(targetPoint, fromCoordinateSpace: superView)
            view = superView
        }
        
        if targetPoint.y > self.view.frame.height - targetPoint.y {
            alert.popoverPresentationController?.permittedArrowDirections = .Down
            alert.popoverPresentationController?.sourceRect = CGRectMake(source.frame.width / 2.0, 0, 1, 1)
        } else {
            alert.popoverPresentationController?.permittedArrowDirections = .Up
            alert.popoverPresentationController?.sourceRect = CGRectMake(source.frame.width / 2.0, source.frame.height, 1, 1)
        }
    }
}