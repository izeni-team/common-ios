//
//  IzeniDispatch.swift
//  Pods
//
//  Created by Skyler Smith on 8/10/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import Foundation

public func delay(delay: Double, completion: (() -> Void)) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
        completion()
    }
}