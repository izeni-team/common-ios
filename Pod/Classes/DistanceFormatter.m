//
// Created by Christopher Henderson on 6/18/14.
// Copyright (c) 2014 Izeni, Inc. All rights reserved.
//

#import "DistanceFormatter.h"

@implementation DistanceFormatter

+ (NSString *)stringFromDistanceInMeters:(double)distanceInMeters units:(DistanceUnitType)units abbreviated:(BOOL)abbreviated {
    // Output
    double number;
    NSUInteger decimalPlaces = 0;
    NSString *suffix = nil;

    // Choose between metric and imperial
    if (!units) units = DistanceUnitTypeImperial | DistanceUnitTypeMetric;
    if (units & DistanceUnitTypeMetric && units & DistanceUnitTypeImperial) {
        BOOL useMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
        DistanceUnitType userPreferredUnitSystem = useMetric ? DistanceUnitTypeMetric : DistanceUnitTypeImperial;
        units = units & userPreferredUnitSystem; // Removes non-local measurement system
        if (!units) units = userPreferredUnitSystem; // Auto select system based on local settings if none provided
    }

    // When to add "s" to the suffix
    BOOL (^pluralSuffix)(double) = ^BOOL(double n) { return abbreviated ? NO : n != 1; };

    // Convert
    if (units & DistanceUnitTypeImperial) {
        double feet = distanceInMeters * 3.28083989501312;
        double yards = feet / 3.0;
        double miles = feet / 5280.0;

        if (units & DistanceUnitTypeImperialMiles && (miles > 1 || units == DistanceUnitTypeImperialMiles)) {
            // Use miles
            number = miles;
            decimalPlaces = miles + 0.005 >= 10 ? 1 : 2; // 3 significant digits; +0.005 is to round to nearest 2 decimal places
            suffix = abbreviated ? @"mi" : @"mile";
        } else if (units & DistanceUnitTypeImperialYards && (feet >= 1000 || units == DistanceUnitTypeImperialYards)) {
            // Use yards
            number = yards;
            decimalPlaces = 0;
            suffix = abbreviated ? @"yd" : @"yard";
        } else {
            // Use feet
            number = feet;
            decimalPlaces = 0;
            suffix = abbreviated ? @"ft" : @"feet";
            pluralSuffix = ^(double n) { return NO; };
        }
    } else { // Metric
        double kilometers = distanceInMeters / 1000.0;

        if (units & DistanceUnitTypeMetricKilometers && (kilometers >= 1 || units == DistanceUnitTypeMetricKilometers)) {
            // Use kilometers
            number = kilometers;
            decimalPlaces = 1;
            suffix = abbreviated ? @"km" : @"kilometer";
        } else {
            // Use meters
            number = distanceInMeters;
            decimalPlaces = 0;
            suffix = abbreviated ? @"m" : @"meter";
        }
    }

    // Cut off to desired number of decimal places
    double multiplier = pow(10, decimalPlaces);
    number = (int)(number * multiplier + 0.5) / multiplier; // +0.5 to round to the nearest decimal place

    // Add a "s" if it should have one
    if (pluralSuffix(number)) suffix = [suffix stringByAppendingString:@"s"];

    // Format the number
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale currentLocale];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.maximumFractionDigits = decimalPlaces;
    NSString *numberString = [numberFormatter stringFromNumber:@(number)];

    return [NSString stringWithFormat:@"%@ %@", numberString, suffix];
}

@end