//
//  Created by Christopher Henderson on 6/17/14.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

static UIViewController *photoSelectionParentController = nil;
static void (^photoSelectionCallback)(NSDictionary *info) = nil;
static BOOL statusBarWasHidden = NO;

@interface UIImagePickerControllerDelegateHandler : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@implementation UIImagePickerControllerDelegateHandler
- (void)callbackWithInfo:(NSDictionary *)info {
    // Show status bar
    if (statusBarWasHidden) {
        statusBarWasHidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }

    // Sanity checks
    NSAssert(photoSelectionParentController, @"Missing photo selection parent controller");
    NSAssert(photoSelectionCallback, @"Missing photo selection callback");

    // Dismiss the picker
    [photoSelectionParentController dismissViewControllerAnimated:YES completion:nil];
    photoSelectionParentController = nil;

    // Callback (copy is to allow the callback to initiate another picker if it wants, without problems...
    void (^callback_copy)(NSDictionary *) = photoSelectionCallback;
    photoSelectionCallback = nil;
    callback_copy(info);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self callbackWithInfo:info];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self callbackWithInfo:nil];
}
@end

// This custom class adds the ability to specify which status bar controller the view controller should have
@interface UIImagePickerControllerMagic : UIImagePickerController
@end
@implementation UIImagePickerControllerMagic
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [self setNeedsStatusBarAppearanceUpdate];
}
@end

@implementation UIImagePickerController (Magic)

+ (UIImagePickerControllerDelegateHandler *)selectPhotoDelegateHandler {
    static UIImagePickerControllerDelegateHandler *handler = nil;
    if (!handler) handler = [[UIImagePickerControllerDelegateHandler alloc] init];
    return handler;
}

+ (void)selectPhotoWithParentController:(UIViewController *)parentController
                             sourceType:(UIImagePickerControllerSourceType)sourceType
                      preferFrontCamera:(BOOL)preferFrontCamera
                          allowsEditing:(BOOL)allowsEditing
                            onDismissed:(void (^)(NSDictionary *info))onDismissed {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Sanity checks
        NSAssert(parentController && onDismissed, @"Parent controller %p and/or callback %p were not given",
                        (__bridge void *)parentController,
                        onDismissed);
        if (photoSelectionCallback || photoSelectionParentController) {
            NSLog(@"ERROR: %s: Cannot show two pickers at once.  Call ignored...", __func__);
            if (onDismissed) onDismissed(nil);
            return;
        }

        // Does the device have a camera?
        if (sourceType == UIImagePickerControllerSourceTypeCamera && ![UIImagePickerController isSourceTypeAvailable:sourceType]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Your device does not have a camera."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
            [alert show];
            return;
        }

        // Save callback info
        photoSelectionCallback = onDismissed;
        photoSelectionParentController = parentController;

        // Configure
        UIImagePickerControllerMagic *picker = [[UIImagePickerControllerMagic alloc] init];
        picker.delegate = self.selectPhotoDelegateHandler;
        picker.allowsEditing = allowsEditing;
        picker.sourceType = sourceType;

        // Hide status bar
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            statusBarWasHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }

        // Front camera?
        if (preferFrontCamera
                && sourceType == UIImagePickerControllerSourceTypeCamera
                && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }

        // Present
        [parentController presentViewController:picker animated:YES completion:nil];
    });
}

@end