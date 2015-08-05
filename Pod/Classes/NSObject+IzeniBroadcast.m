//
// NSObject+IzeniBroadcast.m
//
// Created by Christopher Henderson on 6/2/14.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

#import "NSObject+IzeniBroadcast.h"
#import <objc/runtime.h>

@interface IzeniBroadcastMonitor : NSObject <NSCopying>

@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic) BOOL takesArgument;
- (id)initWithTarget:(id)target selector:(SEL)selector;
@end

@implementation IzeniBroadcastMonitor

- (id)initWithTarget:(id)target selector:(SEL)selector {
    self = [super init];
    self.target = target;
    self.selector = selector;
    self.identifier = [NSString stringWithFormat:@"%@[%@(%p) %s]", target == [target class] ? @"+" : @"-", [target class], (__bridge void *)target, sel_getName(selector)];
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    NSAssert(signature, @"Signature required to know how many arguments are expected");
    self.takesArgument = signature.numberOfArguments > 2; // self and cmd are first 2
    return self;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    IzeniBroadcastMonitor *copy = [[IzeniBroadcastMonitor alloc] init];
    copy.target = self.target;
    copy.selector = self.selector;
    copy.identifier = self.identifier;
    return copy;
}

- (BOOL)isEqual:(id)object {
    return [self.identifier isEqualToString:[(IzeniBroadcastMonitor *)object identifier]];
}

- (NSUInteger)hash {
    return self.identifier.hash;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %@", [self class], self.identifier];
}

@end

@interface IzeniBroadcastDeallocWatcher : NSObject

@property (nonatomic, copy) void (^block)(void);
+ (void)watch:(id)object context:(void *)context block:(void (^)(void))block;

@end

@implementation IzeniBroadcastDeallocWatcher

+ (void)watch:(id)object context:(void *)context block:(void (^)(void))block {
    if (objc_getAssociatedObject(object, context)) {
        return; // Already watching
    }
    
    IzeniBroadcastDeallocWatcher *watcher = [[IzeniBroadcastDeallocWatcher alloc] init];
    watcher.block = block;
    objc_setAssociatedObject(object, context, watcher, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dealloc {
    if (self.block) {
        self.block();
    }
}

@end

// broadcastOp is for thread-safety
static dispatch_once_t izBroadQueueToken;
static dispatch_queue_t izBroadQueue;
static void izeniBroadcastOperation(void (^block)(void)) {
    if (!izBroadQueueToken) {
        dispatch_once(&izBroadQueueToken, ^{
            NSString *unique = @"IzeniBroadcast";
            izBroadQueue = dispatch_queue_create(unique.UTF8String, DISPATCH_QUEUE_SERIAL);
        });
    }
    dispatch_sync(izBroadQueue, block);
}

// This is what holds the broadcast monitoring info
static NSMutableDictionary *root;

@implementation Broadcast

+ (void)emit:(NSUUID *)uuid {
    [Broadcast emit:uuid value:nil synchronously:NO];
}

+ (void)emit:(NSUUID *)uuid synchronously:(BOOL)synchronously {
    [Broadcast emit:uuid value:nil synchronously:synchronously];
}

+ (void)emit:(NSUUID *)uuid value:(id)value {
    [Broadcast emit:uuid value:value synchronously:NO];
}

+ (void)emit:(NSUUID *)uuid value:(id)value synchronously:(BOOL)synchronously {
    __block NSMutableSet *observerSet = nil;
    izeniBroadcastOperation(^{
        // Copy info, to allow mutation during enumeration.
        // This allows targets to stop broadcasting, etc., *inside* of the target's selector.
        observerSet = [root[uuid] copy];
    });
    
    void (^block)() = ^{
        for (IzeniBroadcastMonitor *observer in observerSet) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if (observer.takesArgument) {
                [observer.target performSelector:observer.selector withObject:value];
            } else {
                [observer.target performSelector:observer.selector];
            }
#pragma clang diagnostic pop
        }
    };
    
    if (synchronously) {
        if ([NSThread isMainThread]) {
            // dispatch_sync will deadlock if already on main thread
            block();
        } else {
            dispatch_sync(dispatch_get_main_queue(), block);
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

+ (void)monitorBroadcast:(NSUUID *)uuid target:(id)target selector:(SEL)selector {
    NSAssert(uuid, @"You must specify a uuid");
    NSAssert(selector, @"You must specify a selector");
    NSAssert([target respondsToSelector:selector], @"Selector not implemented");
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        root = [[NSMutableDictionary alloc] init];
    });
    IzeniBroadcastMonitor *observer = [[IzeniBroadcastMonitor alloc] initWithTarget:target selector:selector];
    
    izeniBroadcastOperation(^{
        if (root[uuid] == nil) {
            root[uuid] = [NSMutableSet set];
        }
        [root[uuid] addObject:observer];
        
        // Automatically remove on dealloc
        static int context;
        [IzeniBroadcastDeallocWatcher watch:target context:&context block:^{
            [observer.target stopMonitoringBroadcast:uuid selector:selector];
        }];
    });
}

+ (void)stopMonitoringBroadcast:(NSUUID *)uuid target:(id)target selector:(SEL)selector {
    NSAssert(uuid, @"You must specify a uuid");
    NSAssert(selector, @"You must specify a selector");
    NSAssert([target respondsToSelector:selector], @"Selector not implemented");
    IzeniBroadcastMonitor *observer = [[IzeniBroadcastMonitor alloc] initWithTarget:target selector:selector];
    
    izeniBroadcastOperation(^{
        // Cleanup
        [root[uuid] removeObject:observer];
        if ([root[uuid] count] <= 0) {
            // Nobody is listening to the broadcast anymore
            [root removeObjectForKey:uuid];
        }
    });
}

@end

@implementation NSObject (IzeniBroadcast)

- (void)monitorBroadcast:(NSUUID *)uuid selector:(SEL)selector {
    [Broadcast monitorBroadcast:uuid target:self selector:selector];
}

- (void)stopMonitoringBroadcast:(NSUUID *)uuid selector:(SEL)selector {
    [Broadcast stopMonitoringBroadcast:uuid target:self selector:selector];
}

@end