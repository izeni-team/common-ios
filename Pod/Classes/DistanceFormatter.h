//
//  Created by Christopher Henderson on 6/18/14.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistanceFormatter : NSObject

typedef enum {
    DistanceUnitTypeMetricMeters = 1 << 0,
    DistanceUnitTypeMetricKilometers = 1 << 1,
    DistanceUnitTypeImperialFeet = 1 << 2,
    DistanceUnitTypeImperialYards = 1 << 3,
    DistanceUnitTypeImperialMiles = 1 << 4,

    DistanceUnitTypeAuto = INT_MAX,
    DistanceUnitTypeMetric = DistanceUnitTypeMetricMeters | DistanceUnitTypeMetricKilometers,
    DistanceUnitTypeImperial = DistanceUnitTypeImperialFeet | DistanceUnitTypeImperialYards | DistanceUnitTypeImperialMiles,
} DistanceUnitType;

// Input distance is in meters
// Unlike MapKit, does not round to nearest 100 meters, etc...
+ (NSString *)stringFromDistanceInMeters:(double)distanceInMeters units:(DistanceUnitType)units abbreviated:(BOOL)abbreviated;

@end