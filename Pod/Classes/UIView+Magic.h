//
//  UIView+Magic.h
//  IzeniCommon
//
//  Created by Christopher Henderson on 6/5/14.
//  Copyright (c) 2014 Christopher Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Magic)
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat h;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat horizontalCenter; // Alias for centerX
@property (nonatomic, assign) CGFloat verticalCenter;   // Alias for centerY
@property (nonatomic, assign, readonly) CGPoint centerBounds;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, readonly) CALayer *presentationLayer;
+ (id)x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h;
+ (void)animateWithKeyboardFrameChangeNotification:(NSNotification *)notification inView:(UIView *)view block:(void (^)(CGFloat keyboardYAfterAnimation))block;
+ (void)animateWithKeyboardFrameChangeNotification:(NSNotification *)notification inView:(UIView *)view block:(void (^)(CGFloat keyboardYAfterAnimation))block completed:(void (^)(void))completed;
- (id)initWithRight:(CGFloat)right y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h;
- (id)initWithCenterX:(CGFloat)centerX centerY:(CGFloat)centerY w:(CGFloat)w h:(CGFloat)h;
- (CGFloat)ratioOfHeight:(double)scale; // returns self.h * scale; Useful for when laying out views programmatically...
- (CGPoint)centerInSpaceBetween:(UIView *)otherView;
@end

static inline CGFloat AntiSubpixel(double f) {
    static CGFloat scale = 0;
    if (!scale) { scale = [UIScreen mainScreen].scale; }
    return (int)(f * scale + 0.5) / scale;
}