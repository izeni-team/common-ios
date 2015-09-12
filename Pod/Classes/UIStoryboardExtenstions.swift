//
//  UIStoryboardExtenstions.swift
//  Pods
//
//  Created by Taylor Allred on 7/14/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    public class func instantiate(#from: String, id: String) -> UIViewController {
        return UIStoryboard(name: from, bundle: nil).instantiateViewControllerWithIdentifier(id) as! UIViewController
    }
    
    public class func instantiateInitial(from: String) -> UIViewController {
        return UIStoryboard(name: from, bundle: nil).instantiateInitialViewController() as! UIViewController
    }
}
