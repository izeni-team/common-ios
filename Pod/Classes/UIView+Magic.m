//
//  UIView+Magic.m
//  IzeniCommon
//
//  Created by Christopher Henderson on 6/5/14.
//  Copyright (c) 2014 Christopher Henderson. All rights reserved.
//

#import "UIView+Magic.h"

@implementation UIView (Magic)

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)h {
    return self.frame.size.height;
}

- (void)setH:(CGFloat)h {
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}

- (CGFloat)w {
    return self.frame.size.width;
}

- (void)setW:(CGFloat)w {
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)horizontalCenter {
    return self.centerX;
}

- (void)setHorizontalCenter:(CGFloat)centerX {
    self.centerX = centerX;
}

- (CGFloat)verticalCenter {
    return self.centerY;
}

- (void)setVerticalCenter:(CGFloat)centerY {
    self.centerY = centerY;
}

- (CGPoint)centerBounds {
    return CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CALayer *)presentationLayer {
    return (CALayer *)self.layer.presentationLayer;
}

+ (id)x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h {
    return [[self alloc] initWithFrame:CGRectMake(x, y, w, h)];
}

+ (void)animateWithKeyboardFrameChangeNotification:(NSNotification *)notification inView:(UIView *)view block:(void (^)(CGFloat keyboardYAfterAnimation))block completed:(void (^)(void))completed {
    NSAssert(notification && view && block, @"Invalid args");
    NSDictionary *info = notification.userInfo;

    // This is where the keyboard will be once the animation finishes
    CGRect endRect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    // This will where the keyboard will be in our local view once the animation finishes (our Y might not start at the top of the keyWindow)
    UIView *reference = [[UIApplication sharedApplication] keyWindow].subviews.firstObject;
    CGRect adjusted = [view convertRect:endRect fromView:reference];

    // How to match UIKeyboard animation curve & duration taken from http://stackoverflow.com/a/19236013/2406857
    [UIView beginAnimations:nil context:nil];
    double animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    block(adjusted.origin.y);
    [UIView commitAnimations];

    // Mysterious offset +0.2 is what looks right.  Feel free to adjust if you're super picky about it...
    if (completed) [UIView performSelector:@selector(performBlockAfterDelay:) withObject:completed afterDelay:animationDuration + 0.2];
}

- (id)initWithCenterX:(CGFloat)centerX centerY:(CGFloat)centerY w:(CGFloat)w h:(CGFloat)h {
    return [self initWithFrame:CGRectMake(centerX - w / 2, centerY - h / 2, w, h)];
}

- (CGFloat)ratioOfHeight:(double)scaled {
    return AntiSubpixel(self.h * scaled);
}

- (CGPoint)centerInSpaceBetween:(UIView *)otherView {
    CGRect otherViewFrame = [otherView convertRect:otherView.bounds toView:self.superview];
    return CGPointMake(
            AntiSubpixel(self.right + (otherViewFrame.origin.x - self.right) / 2),
            AntiSubpixel(self.bottom + (otherViewFrame.origin.y - self.bottom) / 2)
    );
}

- (id)initWithRight:(CGFloat)right y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h {
    return [self initWithFrame:CGRectMake(right - w, y, w, h)];
}

+ (void)performBlockAfterDelay:(void (^)(void))block {
    if (block) block();
}

+ (void)animateWithKeyboardFrameChangeNotification:(NSNotification *)notification inView:(UIView *)view block:(void (^)(CGFloat keyboardYAfterAnimation))block {
    [self animateWithKeyboardFrameChangeNotification:notification inView:view block:block completed:nil];
}

@end
