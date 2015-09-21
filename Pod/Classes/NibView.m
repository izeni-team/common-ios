//
//  NibView.m
//  Izeni
//
//  Created by Christopher Bryan Henderson on 9/12/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

#import "NibView.h"

@implementation NibView

+ (NSString *)nameOfClass:(Class)c {
    NSString *className = c.description;
    
    // Get rid of Swift boilerplate
    while ([className containsString:@"."]) {
        className = [className stringByReplacingOccurrencesOfString:@".*\\." withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, className.length)];
    }
    
    return className;
}

+ (void)loadNib:(NSString *)nib owner:(NSObject *)owner {
    UIView *loaded = (UIView *)[[NSBundle mainBundle] loadNibNamed:nib owner:owner options:nil].firstObject;
    [owner setValue:loaded forKey:@"nibView"];
}

- (id)init {
    self = [super init];
    [self setup];
    return self;
~}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (NSString *)nib {
    return [NibView nameOfClass:self.class];
}

- (void)setup {
    [NibView loadNib:self.nib owner:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.nibView];
    self.nibView.frame = self.bounds;
}

@end
