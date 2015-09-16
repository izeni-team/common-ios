//
//  NibCollectionViewCell.m
//  Izeni
//
//  Created by Christopher Bryan Henderson on 9/16/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

#import "NibCollectionViewCell.h"
#import <Izeni/NibView.h>

@implementation NibCollectionViewCell

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

- (NSString *)nibName {
    return [NibView nameOfClass:self.class];
}

- (void)setup {
    return [NibView loadNib:self.nibName owner:self addToView:self.contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nibView.frame = self.contentView.bounds;
}

@end
