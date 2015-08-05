//
//  Created by Christopher Henderson on 7/3/14.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//


@implementation NSLocale (Magic)
+ (BOOL)usesMetricSystem {
    return [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
}
@end