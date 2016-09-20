//
//  UIStoryboardExtenstions.swift
//  Pods
//
//  Created by Taylor Allred on 7/14/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    public class func instantiate(_ from: String, id: String) -> UIViewController {
        return UIStoryboard(name: from, bundle: nil).instantiateViewController(withIdentifier: id) 
    }
    
    public class func instantiateInitial(_ from: String) -> UIViewController {
        return UIStoryboard(name: from, bundle: nil).instantiateInitialViewController()!
    }
}
