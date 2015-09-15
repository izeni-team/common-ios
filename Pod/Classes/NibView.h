//
//  NibView.h
//  Izeni
//
//  Created by Christopher Bryan Henderson on 9/12/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NibView : UIView

+ (NSString *)nameOfClass:(Class)c;
+ (void)loadNib:(NSString *)nib owner:(NSObject *)owner addToView:(UIView *)addToView; // Assigns result to property named "nibView"

@property (nonatomic, assign, readonly) NSString *nib;
@property (nonatomic, strong) UIView *nibView;
- (void)setup;

@end
