//
//  Created by Christopher Henderson on 6/17/14.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

@interface UIImagePickerController (Magic)

// Info will be nil if user cancelled
//
// NOTE: For this to work properly, you must make UIViewControllerBasedStatusBarAppearance true in your plist
//
// WARNING: It is *STRONGLY* advised that you NEVER use -[UIApplication setStatusBarStyle:] in your code.
// It would be much better to:
//   1. In your view controller, override -[UIViewController preferredStatusBarStyle]
//   2. Call -[UIViewController setNeedsStatusBarStyleUpdate] anytime you need the value returned by
//      -preferredStatusBarStyle to be applied
//
+ (void)selectPhotoWithParentController:(UIViewController *)parentController
                             sourceType:(UIImagePickerControllerSourceType)sourceType
                      preferFrontCamera:(BOOL)preferFrontCamera
                          allowsEditing:(BOOL)allowsEditing
                            onDismissed:(void (^)(NSDictionary *info))onDismissed;

@end