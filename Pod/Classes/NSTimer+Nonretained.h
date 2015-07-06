//
// Created by Christopher Henderson on 7/11/14.
// Copyright (c) 2014 Izeni, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Nonretained)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval nonretainedTarget:(id)nonretainedTarget selector:(SEL)selector;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval nonretainedTarget:(id)nonretainedTarget selector:(SEL)selector repeats:(BOOL)repeats;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval nonretainedTarget:(id)nonretainedTarget selector:(SEL)selector userInfo:(id)userInfo;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval nonretainedTarget:(id)nonretainedTarget selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;
@end