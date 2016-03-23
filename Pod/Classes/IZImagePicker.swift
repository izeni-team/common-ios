//
//  IZImagePicker.swift
//  Izeni, Inc
//
//  Created by Mitchell Tenney on 3/23/16.
//      Code references from Christopher Bryan Henderson - ImagePicker.swift
//  Copyright © 2016 Izeni, Inc. All rights reserved.
//

import PEPhotoCropEditor
import AVFoundation
import Photos

@objc public protocol IZImagePickerDelegate: class {
    func imagePicked(image: UIImage)
    optional func imagePickCancelled()
}

public class IZImagePicker: NSObject, UIImagePickerControllerDelegate, PECropViewControllerDelegate, UINavigationControllerDelegate {
    private var parentVC: UIViewController!
    private var delegate: IZImagePickerDelegate!
    private var aspectRatio: CGFloat? = 1
    private var preferFrontCamera: Bool = false
    
    public var popoverSource: UIView! // iPad
    
    private var cameraPermissionGranted: Bool = false
    private var libraryPermissionGranted: Bool = false
    
    private var permissionsRequested: Bool = false
    
    private var isCameraAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    private var isLibraryAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
    }
    
    public var isIpad: Bool {
        return UIDevice.currentDevice().userInterfaceIdiom == .Pad
    }
    
    private override init() {}
    public static let instance = IZImagePicker()
    
    // MARK: - User Allowed Functions
    public func pickImage(delegate delegate: IZImagePickerDelegate, vc: UIViewController) {
        assert(NSBundle.allFrameworks().map { $0.bundleURL.lastPathComponent! }.contains("PEPhotoCropEditor.framework"), "Your project does not contain the PEPhotoCropEditor bundle. Try creating a reference to it in your main project. You can do this by adding the PEPhotoCropEditor.bundle to your main project and uncheck the \"copy\" box.")
        
        self.delegate = delegate
        self.parentVC = vc
        
        showPickerSourceAlert()
    }
    
    
    public func pickImage(delegate delegate: IZImagePickerDelegate, vc: UIViewController, aspectRatio: CGFloat?) {
        self.aspectRatio = aspectRatio
        pickImage(delegate: delegate, vc: vc)
    }
    
    public func pickImage(delegate delegate: IZImagePickerDelegate, vc: UIViewController, preferFrontCamera: Bool) {
        self.preferFrontCamera = preferFrontCamera
        pickImage(delegate: delegate, vc: vc)
    }
    
    public func pickImage(delegate delegate: IZImagePickerDelegate, vc: UIViewController, aspectRatio: CGFloat?, preferFrontCamera: Bool) {
        self.preferFrontCamera = preferFrontCamera
        self.aspectRatio = aspectRatio
        pickImage(delegate: delegate, vc: vc)
    }
    
    public func setPopoverSourceForIPad(source: UIView) {
        self.popoverSource = source
    }
    
    public func setPreferFrontCamera(preferFrontCamera: Bool) {
        self.preferFrontCamera = preferFrontCamera
    }
    
    // MARK: - Camera Actions
    
    private func takePhoto() {
        if cameraPermissionGranted {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .Camera // Defaults to .PhotoLibrary
            if preferFrontCamera &&
                UIImagePickerController.isCameraDeviceAvailable(.Front) {
                picker.cameraDevice = .Front
            }
            show(picker)
        } else {
            requestCameraPermission()
        }
    }
    
    // MARK: - Library Actions
    
    private func pickLibraryPhoto() {
        if libraryPermissionGranted {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .PhotoLibrary
            show(picker)
        } else {
            requestLibraryPermission()
        }
    }
    
    // MARK: - Permissions
    
    private func requestCameraPermission() {
        cameraPermissionGranted = false
        let authorization = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        // https://developer.apple.com/library/ios/documentation/AVFoundation/Reference/AVCaptureDevice_Class/#//apple_ref/swift/enum/c:@E@AVAuthorizationStatus
        print("\tCamera Permission: \(getAuthorizationType(authorization))")
        switch authorization {
        case .Authorized:
            // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
            cameraPermissionGranted = true
            break
        case .Restricted:
            // The user is not allowed to access media capture devices.
            restrictedAlert("Camera")
            break
        case .Denied:
            // The user has explicitly denied permission for media capture.
            deniedAlert("Camera")
            break
        case .NotDetermined:
            // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (allow) in
                self.cameraPermissionGranted = allow
                self.takePhoto()
            })
            break
        }
    }
    
    private func requestLibraryPermission() {
        libraryPermissionGranted = false
        let authorization = PHPhotoLibrary.authorizationStatus()
        // https://developer.apple.com/library/ios/documentation/Photos/Reference/PHPhotoLibrary_Class/#//apple_ref/swift/enum/c:@E@PHAuthorizationStatus
        print("\tLibrary Permission: \(getAuthorizationType(authorization))")
        switch authorization {
        case .Authorized:
            // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
            libraryPermissionGranted = true
            break
        case .Restricted:
            // The user is not allowed to access media capture devices.
            restrictedAlert("Photo Library")
            break
        case .Denied:
            // The user has explicitly denied permission for media capture.
            deniedAlert("Photo Library")
            break
        case .NotDetermined:
            // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
            PHPhotoLibrary.requestAuthorization { (allow) in
                self.libraryPermissionGranted = (allow == .Authorized)
                self.pickLibraryPhoto()
            }
            break
        }
    }
    
    private func getAuthorizationType(authorization: AVAuthorizationStatus) -> String {
        var authName = ""
        switch authorization {
        case .Authorized:
            authName = "Authorized"
            break
        case .Restricted:
            authName = "Restricted"
            break
        case .Denied:
            authName = "Denied"
            break
        case .NotDetermined:
            authName = "Not Determined"
            break
        }
        return authName
    }
    
    private func getAuthorizationType(authorization: PHAuthorizationStatus) -> String {
        var authName = ""
        switch authorization {
        case .Authorized:
            authName = "Authorized"
            break
        case .Restricted:
            authName = "Restricted"
            break
        case .Denied:
            authName = "Denied"
            break
        case .NotDetermined:
            authName = "Not Determined"
            break
        }
        return authName
    }
    
    private func canUseCamera() -> Bool {
        return isCameraAvailable && cameraPermissionGranted
    }
    
    private func canUseLibrary() -> Bool {
        return isLibraryAvailable && libraryPermissionGranted
    }
    
    // MARK: - Alerts
    
    private func show(vc: UIViewController) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = vc as? UIAlertController
            if self.isIpad && alert?.preferredStyle == .ActionSheet {
                let popover = UIPopoverController(contentViewController: vc)
                popover.presentPopoverFromRect(self.popoverSource.bounds, inView: self.popoverSource, permittedArrowDirections: .Any, animated: true)
            } else {
                self.parentVC.presentViewController(vc, animated: true, completion: nil)
            }
        })
    }
    
    private func showPickerSourceAlert() {
        let alert = UIAlertController()
        if isCameraAvailable {
            alert.addAction(UIAlertAction(title: "Take Photo", style: .Default) { _ in
                self.takePhoto()
                })
        }
        if isLibraryAvailable {
            alert.addAction(UIAlertAction(title: "Choose From Library", style: .Default) { _ in
                self.pickLibraryPhoto()
                })
        }
        if alert.actions.count == 1 {
            if isCameraAvailable {
                takePhoto()
            }
            if isLibraryAvailable {
                pickLibraryPhoto()
            }
        } else if alert.actions.count == 2 {
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { _ in }))
            show(alert)
        } else {
            print("[WARN]\tIZImagePicker - No Access given for Camera or Photo Library")
            deniedAlert("Camera and Photo Library")
        }
    }
    
    private func restrictedAlert(accessType: String) {
        let authAlert = UIAlertController(title: "\(accessType) Access is Restricted",
                                          message: "\(getAppName()) could not access the \(accessType) on this device.",
                                          preferredStyle: .Alert)
        authAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { _ in }))
        show(authAlert)
    }
    
    private func deniedAlert(accessType: String) {
        let authAlert = UIAlertController(title: "\(accessType) Access is Denied", message: "\(getAppName()) does not have access to your \(accessType). You can enable access in privacy settings.", preferredStyle: .Alert)
        authAlert.addAction(UIAlertAction(title: "Settings", style: .Cancel, handler: { (action) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        authAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { _ in }))
        show(authAlert)
    }
    
    // MARK: - Helpers
    
    private func getAppName() -> String {
        return NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
    }
    
}

// MARK: - PECropViewControllerDelegate

extension IZImagePicker {
    public func cropViewController(controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        delegate.imagePicked(croppedImage)
    }
    
    public func cropViewControllerDidCancel(controller: PECropViewController!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        delegate.imagePickCancelled?()
    }
}

// MARK: - UIImagePickerControllerDelegate

extension IZImagePicker {
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let controller = PECropViewController()
        controller.delegate = self
        controller.image = image
        if let ar = aspectRatio {
            controller.keepingCropAspectRatio = true
            controller.cropAspectRatio = ar
        } else {
            controller.keepingCropAspectRatio = false
        }
        controller.toolbarHidden = true
        
        let navController = UINavigationController(rootViewController: controller)
        show(navController)
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        delegate.imagePickCancelled?()
    }}