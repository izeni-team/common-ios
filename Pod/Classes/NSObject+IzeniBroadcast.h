//
// NSObject+IzeniBroadcast.h
//
// Created by Christopher Henderson on 6/2/14.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

// This category allows bus-like events to be globally communicated.
// When a broadcast is "emitted," every target and selector listening
// will receive the event (and the event data).  The basic idea behind
// broadcasts is to allow two unrelated classes to communicate
// events with minimal binding.  In other words, using broadcasts is
// simpler than using multiple delegates, because broadcasts are
// loosely coupled (while delegates are tightly coupled).

#define RETURN_STATIC_UUID \
static dispatch_once_t once_token; \
static NSUUID *static_uuid = nil; \
dispatch_once(&once_token, ^{ \
static_uuid = [NSUUID UUID]; \
}); \
return static_uuid;

#import <Foundation/Foundation.h>

@interface Broadcast : NSObject
+ (void)emit:(NSUUID *)uuid; // Not synchronous, dispatched on main thread
+ (void)emit:(NSUUID *)uuid synchronously:(BOOL)synchronously; // Dispatched on main thread
+ (void)emit:(NSUUID *)uuid value:(id)value; // Not synchronous, dispatched on main thread
+ (void)emit:(NSUUID *)uuid value:(id)value synchronously:(BOOL)synchronously; // Dispatched on main thread
@end

@interface NSObject (IzeniBroadcast)
- (void)monitorBroadcast:(NSUUID *)uuid selector:(SEL)selector;
- (void)stopMonitoringBroadcast:(NSUUID *)uuid selector:(SEL)selector;
@end