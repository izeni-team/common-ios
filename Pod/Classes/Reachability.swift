//
//  Reachability.swift
//  Brower
//
//  Created by Skyler Smith on 6/4/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import Foundation
import SCNetworkReachability
import EDQueue

class Reachability {
    private static var singleton: Reachability!
    var watcher: SCNetworkReachability!
    static var isReachable = true
    private static let defaultHost = "http://8.8.8.8"
    static let changedBroadcast = NSUUID()
    
    class func initialize() {
        singleton = Reachability()
        singleton.watcher = SCNetworkReachability(host: defaultHost)
        
        singleton.watcher.observeReachability { status in
            let wasReachable = Reachability.isReachable
            Reachability.isReachable = status != .NotReachable
            if Reachability.isReachable != wasReachable {
                Broadcast.emit(Reachability.changedBroadcast, value: NSNumber(bool: Reachability.isReachable))
            }
        }
    }
}