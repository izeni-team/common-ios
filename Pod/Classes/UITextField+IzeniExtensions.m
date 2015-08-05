//
//  UITextField+IzeniExtensions
//  Pods
//
//  Created by Skyler Smith on 8/4/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

#import "UITextField+IzeniExtensions.h"
#import <objc/runtime.h>

@implementation UITextField (IzeniExtensions)

static int maximumLengthKey;

- (NSInteger)maxLength {
    NSNumber *max = objc_getAssociatedObject(self, &maximumLengthKey);
    if (max != nil) {
        return max.integerValue;
    } else {
        return NSNotFound;
    }
}

- (void)setMaxLength:(NSInteger)maximumLength {
    if (objc_getAssociatedObject(self, &maximumLength) == nil) {
        // "init" here
        [self addTarget:self action:@selector(izeniExtTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    objc_setAssociatedObject(self, &maximumLengthKey, @(maximumLength), OBJC_ASSOCIATION_RETAIN);
}

- (void)izeniExtTextDidChange:(UITextField *)textField {
    if (textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
    }
}

@end
