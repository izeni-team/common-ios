//
//  NibView.h
//  Izeni
//
//  Created by Christopher Bryan Henderson on 9/12/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NibView : UIView

+ (NSString * _Nonnull)nameOfClass:(Class _Nonnull)c;
+ (void)loadNib:(NSString * _Nonnull)nib owner:(NSObject * _Nonnull)owner; // Assigns result to property named "nibView"

@property (nonatomic, assign, readonly, nonnull) NSString *nib;
@property (nonatomic, strong, nonnull) UIView *nibView;
- (void)setup;

@end
