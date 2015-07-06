//
// Created by Thane Brimhall on 7/1/14.
// Copyright (c) 2014 Weave. All rights reserved.
//

#import "NSArray+Magic.h"


@implementation NSArray (Magic)

- (NSArray *)reversed {
    return [[self reverseObjectEnumerator] allObjects];
}

@end