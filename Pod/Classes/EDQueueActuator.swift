//
//  EDQueueActuator.swift
//  Brower
//
//  Created by Skyler Smith on 6/4/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

import Foundation
import EDQueue

public class EDQueueActuator: NSObject, EDQueueDelegate {
    
    public static let singleton = EDQueueActuator()
    private let defaultCenter = NSNotificationCenter()
    public let delayTime: NSTimeInterval = 60
    public var resumeTimer: NSTimer?
    
    public class func start() {
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
    
    public func reachabilityChanged(reachable: NSNumber) {
        if reachable.boolValue {
            EDQueue.sharedInstance().start()
            println("reachable")
        } else {
            println("not reachable")
            EDQueue.sharedInstance().stop()
        }
    }
    
    public func queue(queue: EDQueue!, processJob job: [NSObject : AnyObject]!, completion block: EDQueueCompletionBlock!) {
        fatalError("This function must be overridden")
    }
    
    public func scheduleStart(#delay: Bool) {
        resumeTimer?.invalidate()
        if delay {
            resumeTimer = NSTimer.scheduledTimerWithTimeInterval(delayTime, target: self, selector: "startTimeout", userInfo: nil, repeats: false )
        } else {
            EDQueue.sharedInstance().start()
        }
    }
    
    public func startTimeout() {
        if Reachability.isReachable {
            EDQueue.sharedInstance().start()
        }
    }
    
    public func applicationWillResignActive() {
        EDQueue.sharedInstance().stop()
    }
    
    public func applicationDidBecomeActive() {
        EDQueue.sharedInstance().delegate = self
        EDQueue.sharedInstance().retryLimit = UInt.max
        scheduleStart(delay: false)
    }
    
    
}