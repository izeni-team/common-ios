//
//  UITextField+IzeniExtensions
//  Pods
//
//  Created by Skyler Smith on 8/4/15.
//
//

#import "UITextField+IzeniExtensions.h"
#import <objc/runtime.h>

@implementation UITextField (IzeniExtensions)

static int maximumLengthKey;

- (NSInteger)maximumLength {
    NSNumber *max = objc_getAssociatedObject(self, &maximumLengthKey);
    if (max != nil) {
        return max.integerValue;
    } else {
        return NSNotFound;
    }
}

- (void)setMaximumLength:(NSInteger)maximumLength {
    if (objc_getAssociatedObject(self, &maximumLength) == nil) {
        // "init" here
        [self addTarget:self action:@selector(izeniExtTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    objc_setAssociatedObject(self, &maximumLengthKey, @(maximumLength), OBJC_ASSOCIATION_RETAIN);
}

- (void)izeniExtTextDidChange:(UITextField *)textField {
    if (textField.text.length > self.maximumLength) {
        textField.text = [textField.text substringToIndex:self.maximumLength];
    }
}

@end
