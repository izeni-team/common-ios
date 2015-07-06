//
// Created by Christopher Henderson on 7/3/14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//


@implementation NSLocale (Magic)
+ (BOOL)usesMetricSystem {
    return [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
}
@end