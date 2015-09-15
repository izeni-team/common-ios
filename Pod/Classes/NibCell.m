//
//  NibCell.m
//  Izeni
//
//  Created by Christopher Bryan Henderson on 9/12/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

#import "NibCell.h"
#import "NibView.h"

@implementation NibCell

- (id)init {
    self = [super init];
    [self setup];
    return self;
}

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
    [NibView loadNib:self.nib owner:self addToView:self.contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nibView.frame = self.contentView.bounds;
}

@end
