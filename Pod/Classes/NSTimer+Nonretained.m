//
// Created by Christopher Henderson on 7/11/14.
// Copyright (c) 2014 Izeni, Inc. All rights reserved.
//

#import "NSTimer+Nonretained.h"

@interface NSTimerNonretainedHelper : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;
@property (nonatomic) BOOL takesArgument;
@property (nonatomic, strong) id userInfo;
+ (NSTimerNonretainedHelper *)target:(id)target selector:(SEL)selector userInfo:(id)userInfo;
@end

@implementation NSTimerNonretainedHelper

+ (NSTimerNonretainedHelper *)target:(id)target selector:(SEL)selector userInfo:(id)userInfo {
    NSTimerNonretainedHelper *c = [[NSTimerNonretainedHelper alloc] init];
    c.target = target;
    c.selector = selector;
    c.takesArgument = [target methodSignatureForSelector:selector].numberOfArguments > 2; // First 2 are self and _cmd
    c.userInfo = userInfo;
    return c;
}

@end

static id nilSentinel = nil;

@implementation NSTimer (Nonretained)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval nonretainedTarget:(id)nonretainedTarget selector:(SEL)selector {
    return [NSTimer scheduledTimerWithTimeInterval:interval nonretainedTarget:nonretainedTarget selector:selector userInfo:nil repeats:NO];
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval nonretainedTarget:(id)nonretainedTarget selector:(SEL)selector repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:interval nonretainedTarget:nonretainedTarget selector:selector userInfo:nil repeats:repeats];
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval nonretainedTarget:(id)nonretainedTarget selector:(SEL)selector userInfo:(id)userInfo {
    return [NSTimer scheduledTimerWithTimeInterval:interval nonretainedTarget:nonretainedTarget selector:selector userInfo:userInfo repeats:NO];
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval nonretainedTarget:(id)nonretainedTarget selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        nilSentinel = [NSObject alloc]; // Initialization not necessary; we only need a unique segment of memory
    });

    // Start the timer
    NSTimerNonretainedHelper *info = [NSTimerNonretainedHelper target:nonretainedTarget selector:selector userInfo:userInfo];
    return [NSTimer scheduledTimerWithTimeInterval:interval target:[NSTimer class] selector:@selector(nonretainedTimerTick:) userInfo:info repeats:repeats];
}

+ (void)nonretainedTimerTick:(NSTimer *)timer {
    NSTimerNonretainedHelper *info = timer.userInfo;
    if (info.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (info.takesArgument) {
            [info.target performSelector:info.selector withObject:info.userInfo];
        } else {
            [info.target performSelector:info.selector];
        }
#pragma clang diagnostic pop
    } else {
        [timer invalidate];
    }
}

@end