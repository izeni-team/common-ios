//
//  NibCell.h
//  Izeni
//
//  Created by Christopher Bryan Henderson on 9/12/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NibCell : UITableViewCell

@property (nonatomic, assign, readonly) NSString *nib;
@property (nonatomic, strong) UIView *nibView;
- (void)setup;

@end
