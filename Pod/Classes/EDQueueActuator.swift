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
    
    /// Set this to job processing function
    
    public static let singleton = EDQueueActuator()
    private let defaultCenter = NSNotificationCenter()
    private let delayTime: NSTimeInterval = 5
    private var resumeTimer: NSTimer?
    /// An array of all the queues being processed.
    public var queues = [EDQueue]()
    private var processJob = { (queue: EDQueue, processJob: [String:AnyObject], completion: EDQueueCompletionBlock) -> Void in }
    
    /**
    Call this before beginning to use the Queues.
    
    :param: additionalQueues An array of supplementary queues that will be processed with the default queue.
    :param: process The function called when a job will be processed.
    */
    public class func start(#additionalQueues: [EDQueue], process: (queue: EDQueue, processJob: [String:AnyObject], completion: EDQueueCompletionBlock) -> Void) {
        singleton.queues = [EDQueue.sharedInstance()] + additionalQueues
        singleton.processJob = process
        if Reachability.isReachable {
            for queue in singleton.queues {
                queue.delegate = singleton
                queue.retryLimit = UInt.max
            }
            singleton.startQueues()
        }
    }
    
    override init() {
        super.init()
        
        monitorBroadcast(Reachability.changedBroadcast, selector: "reachabilityChanged:")
        Reachability.initialize()
        
        reachabilityChanged(Reachability.isReachable)
        
        defaultCenter.addObserver(self, selector: "applicationWillResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        defaultCenter.addObserver(self, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        EDQueue.sharedInstance().delegate = self
    }
    
    public func reachabilityChanged(reachable: NSNumber) {
        if reachable.boolValue {
            startQueues()
            println("reachable")
        } else {
            stopQueues()
            println("not reachable")
        }
    }
    
    private func startQueues() {
        for queue in queues {
            queue.start()
        }
    }
    
    private func stopQueues() {
        for queue in queues {
            queue.stop()
        }
    }
    
    /**
    This function is called when a task reaches the front of the queue. It must be overridden.
    
    :param: queue The EDQueue with the task
    :param: job The dictionary of values that was passed into the queue when the task was created.
    :param: block Options are .Success, .Fail (Job will be retried), and .Critical (Job will not be retried).
    */
    public func queue(queue: EDQueue!, processJob job: [NSObject : AnyObject]!, completion block: EDQueueCompletionBlock!) {
        let overriddenBlock = { (result: EDQueueResult) -> Void in
            switch result {
            case .Success:
                block(.Success)
            case .Critical:
                block(.Critical)
            case .Fail:
                block(.Fail)
                self.scheduleStart(delay: true)
            }
        }
        
        processJob(queue, job as! [String:AnyObject], overriddenBlock)
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
            startQueues()
        }
    }
    
    /**
    Starts the queues if internet is reachable.
    */
    public func startTimeout() {
        if Reachability.isReachable  {
            startQueues()
        }
    }
    
    public func applicationWillResignActive() {
        stopQueues()
    }
    
    public func applicationDidBecomeActive() {
        scheduleStart(delay: false)
    }
    
    public func clearQueues() {
        for queue in queues {
            queue.empty()
        }
    }
    
    
}