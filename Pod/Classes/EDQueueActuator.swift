//
//  EDQueueActuator.swift
//  Brower
//
//  Created by Skyler Smith on 6/4/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

import Foundation
import EDQueue

class EDQueueActuator: NSObject, EDQueueDelegate {
    
    static let singleton = EDQueueActuator()
    private let defaultCenter = NSNotificationCenter()
    let delayTime: NSTimeInterval = 60
    var resumeTimer: NSTimer?
    
    class func start() {
        singleton
    }
    
    override init() {
        super.init()
        
        monitorBroadcast(Reachability.changedBroadcast, selector: "reachabilityChanged:")
        Reachability.initialize()
        
        reachabilityChanged(Reachability.isReachable)
        
        defaultCenter.addObserver(self, selector: "applicationWillResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        defaultCenter.addObserver(self, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func reachabilityChanged(reachable: NSNumber) {
        if reachable.boolValue {
            EDQueue.sharedInstance().start()
            println("reachable")
        } else {
            println("not reachable")
            EDQueue.sharedInstance().stop()
        }
    }
    
    func queue(queue: EDQueue!, processJob job: [NSObject : AnyObject]!, completion block: EDQueueCompletionBlock!) {
        fatalError("This function must be overridden")
    }
    
    func scheduleStart(#delay: Bool) {
        resumeTimer?.invalidate()
        if delay {
            resumeTimer = NSTimer.scheduledTimerWithTimeInterval(delayTime, target: self, selector: "startTimeout", userInfo: nil, repeats: false )
        } else {
            EDQueue.sharedInstance().start()
        }
    }
    
    func startTimeout() {
        if Reachability.isReachable {
            EDQueue.sharedInstance().start()
        }
    }
    
    func applicationWillResignActive() {
        EDQueue.sharedInstance().stop()
    }
    
    func applicationDidBecomeActive() {
        EDQueue.sharedInstance().delegate = self
        EDQueue.sharedInstance().retryLimit = UInt.max
        scheduleStart(delay: false)
    }
    
    
}