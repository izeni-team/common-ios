//
//  EDQueueActuator.swift
//  Brower
//
//  Created by Skyler Smith on 6/4/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import Foundation
import EDQueue

public class EDQueueActuator: NSObject, EDQueueDelegate {
    
    public static let singleton = EDQueueActuator()
    private let defaultCenter = NSNotificationCenter()
    public let delayTime: NSTimeInterval = 60
    public var resumeTimer: NSTimer?
    public var needsInternet = true
    
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
        } else if needsInternet {
            println("not reachable")
            EDQueue.sharedInstance().stop()
        }
    }
    
    /**
    This function is called when a task reaches the front of the queue. It must be overridden.
    
    :param: queue The EDQueue with the task
    :param: job The dictionary of values that was passed into the queue when the task was created.
    :param: block Options are .Success, .Fail (Job will be retried), and .Critical (Job will not be retried).
    */
    public func queue(queue: EDQueue!, processJob job: [NSObject : AnyObject]!, completion block: EDQueueCompletionBlock!) {
        fatalError("This function must be overridden")
    }
    
    /**
    Start the queue
    
    :param: delay if true, start the queue after the interval in the stored property delayTime. If false, start immediately.
    */
    public func scheduleStart(#delay: Bool) {
        resumeTimer?.invalidate()
        if delay {
            resumeTimer = NSTimer.scheduledTimerWithTimeInterval(delayTime, target: self, selector: "startTimeout", userInfo: nil, repeats: false )
        } else {
            EDQueue.sharedInstance().start()
        }
    }
    /**
    If needsInternet is false, starts the queue. If needsInternet is true, starts the queue if internet is marked as reachable.
    */
    public func startTimeout() {
        if Reachability.isReachable || !needsInternet {
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