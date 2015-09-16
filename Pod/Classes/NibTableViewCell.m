//
//  NibTableViewCell.m
//  Izeni
//
//  Created by Christopher Bryan Henderson on 9/12/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

#import "NibTableViewCell.h"
#import "NibView.h"

@implementation NibTableViewCell

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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
