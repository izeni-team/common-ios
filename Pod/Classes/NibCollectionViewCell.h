//
//  NibCollectionViewCell.h
//  Izeni
//
//  Created by Christopher Bryan Henderson on 9/16/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NibCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign, readonly) NSString *nibName;
@property (nonatomic, strong) UIView *nibView;

@end
