//
//  ImagePicker.swift
//  IzeniCommon
//
//  Created by Christopher Bryan Henderson on 6/3/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import UIKit
import PEPhotoCropEditor
import AVFoundation

@objc public protocol ImagePickerDelegate: class {
    /**
    imagePicked() is called when the user has finished selecting and cropping an image.
    
    - parameter image: The resulting image after being cropped.
    */
    func imagePicked(image: UIImage)
    
    /**
    imagePickCancelled() is called when the user taps 'cancel' and closes the image picker.
    */
    optional func imagePickCancelled()
}

private let iPad = UIDevice.currentDevice().userInterfaceIdiom == .Pad

public class ImagePicker: NSObject, UIImagePickerControllerDelegate, PECropViewControllerDelegate, UINavigationControllerDelegate {
    private var parentVC: UIViewController!
    private var delegate: ImagePickerDelegate!
    private var aspectRatio: CGFloat?
    public var popoverSource: UIView! // Required for iPad
    public static var singleton = ImagePicker()
    public static var allowChoosingFromLibrary = true
    public static var allowTakingPhoto = true
    public static var takePhotoTitle = "Take Photo"
    public static var chooseFromLibraryTitle = "Choose from Library"
    public class var isLibraryAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
    }
    
    /**
    Opens a popover from which the user may select an image from their photo library or take a new picture.
    Cropping aspect ratio defaults to a square.
    
    - parameter from: The UIViewController that will present the popover alert.
    - parameter popoverSource: For iPad: The UIView that defines where the popover will be placed.
    - parameter delegate: the ImagePickerDelegate that will receive calls to imagePicked() and, if implemeneted, imagePickCancelled().
    */
    public class func pickImage(from from: UIViewController, popoverSource: UIView, delegate: ImagePickerDelegate) {
        _pickImage(from: from, popoverSource: popoverSource, delegate: delegate, aspectRatio: 1, preferFrontCamera: false) // Defaults to a square
    }
    
    /**
    Opens a popover from which the user may select an image from their photo library or take a new picture.
    
    - parameter from: The UIViewController that will present the popover alert.
    - parameter popoverSource: For iPad: The UIView that defines where the popover will be placed.
    - parameter delegate: the ImagePickerDelegate that will receive calls to imagePicked() and, if implemeneted, imagePickCancelled().
    - parameter aspectRatio: the aspect ratio you wish to lock cropping to. Specify 1 for a square, nil to let the user decide.
    */
    public class func pickImage(from from: UIViewController, popoverSource: UIView, delegate: ImagePickerDelegate, aspectRatio: CGFloat?) {
        _pickImage(from: from, popoverSource: popoverSource, delegate: delegate, aspectRatio: aspectRatio, preferFrontCamera: false)
    }
    
    public class func pickImage(from from: UIViewController, popoverSource: UIView, delegate: ImagePickerDelegate, aspectRatio: CGFloat?, preferFrontCamera: Bool) {
        _pickImage(from: from, popoverSource: popoverSource, delegate: delegate, aspectRatio: aspectRatio, preferFrontCamera: preferFrontCamera)
    }
    
    class func _pickImage(from from: UIViewController, popoverSource: UIView, delegate: ImagePickerDelegate, aspectRatio: CGFloat?, preferFrontCamera: Bool) {
        assert(NSBundle.allFrameworks().map { $0.bundleURL.lastPathComponent! }.contains("PEPhotoCropEditor.framework"), "Your project does not contain the PEPhotoCropEditor bundle. Try creating a reference to it in your main project. You can do this by adding the PEPhotoCropEditor.bundle to your main project and uncheck the \"copy\" box.")
        
        singleton.parentVC = from
        singleton.popoverSource = popoverSource
        singleton.delegate = delegate
        singleton.aspectRatio = aspectRatio

        let appName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        print("camera available: \(UIImagePickerController.isSourceTypeAvailable(.Camera))")
        
        switch status {
        case .Restricted:
            let authAlert = UIAlertController(title: "Camera is Restricted", message: "\(appName) could not access the camera on this device.", preferredStyle: .Alert)
            authAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { _ in
            }))
            self.singleton.show(authAlert)
        case .Denied:
            let authAlert = UIAlertController(title: "Camera Access is Disabled", message: "\(appName) does not have access to your camera. You can enable access in privacy settings.", preferredStyle: .Alert)
            authAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { _ in
            }))
            self.singleton.show(authAlert)
        case AVAuthorizationStatus.NotDetermined:
            fallthrough
        case AVAuthorizationStatus.Authorized:
            let alert = UIAlertController()
            if allowTakingPhoto && UIImagePickerController.isSourceTypeAvailable(.Camera) {
                alert.addAction(UIAlertAction(title: takePhotoTitle, style: .Default) { _ in
                    self.singleton.pickImage(.Camera, preferFrontCamera: preferFrontCamera)
                    })
            }
            if allowChoosingFromLibrary && UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                alert.addAction(UIAlertAction(title: chooseFromLibraryTitle, style: .Default) { _ in
                    self.singleton.pickImage(.PhotoLibrary, preferFrontCamera: preferFrontCamera)
                    })
            }
            if alert.actions.isEmpty {
                let alert = UIAlertController(title: "Photos Unavailable", message: "Your device does not appear to have either a camera or photo library.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { _ in }))
                from.presentViewController(alert, animated: true, completion: nil)
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { _ in }))
            singleton.show(alert)
        }
    }

    public func show(vc: UIViewController) {
        if iPad {
            let popover = UIPopoverController(contentViewController: vc)
            popover.presentPopoverFromRect(popoverSource.bounds, inView: popoverSource, permittedArrowDirections: .Any, animated: true)
        } else {
            parentVC.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    public func pickImage(type: UIImagePickerControllerSourceType, preferFrontCamera: Bool) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        if preferFrontCamera && picker.sourceType == .Camera && UIImagePickerController.isCameraDeviceAvailable(.Front) {
            picker.cameraDevice = UIImagePickerControllerCameraDevice.Front;
        }
        show(picker)
    }
    
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
    }
    
    public func cropViewController(controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        delegate.imagePicked(croppedImage)
    }
    
    public func cropViewControllerDidCancel(controller: PECropViewController!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        delegate.imagePickCancelled?()
    }
}