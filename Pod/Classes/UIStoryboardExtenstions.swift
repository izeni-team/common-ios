//
//  UIStoryboardExtenstions.swift
//  Pods
//
//  Created by Taylor Allred on 7/14/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    public convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
}
