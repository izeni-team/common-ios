//
//  ImagePicker.swift
//  IzeniCommon
//
//  Created by Christopher Bryan Henderson on 6/3/15.
//  Copyright (c) 2015 Christopher Bryan Henderson. All rights reserved.
//

import UIKit
import PEPhotoCropEditor

@objc protocol ImagePickerDelegate: class {
    func imagePicked(image: UIImage)
    optional func imagePickCancelled()
}

private let iPad = UIDevice.currentDevice().userInterfaceIdiom == .Pad

public class ImagePicker: NSObject, UIImagePickerControllerDelegate, PECropViewControllerDelegate, UINavigationControllerDelegate {
    public var parentVC: UIViewController!
    var delegate: ImagePickerDelegate!
    public var popoverSource: UIView! // Required for iPad
    public static var singleton = ImagePicker()
    
    public class var isLibraryAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
    }
    
    class func pickImage(#from: UIViewController, popoverSource: UIView, delegate: ImagePickerDelegate) {
        singleton.delegate = delegate
        singleton.parentVC = from
        singleton.popoverSource = popoverSource
        
        let alert = UIAlertController()
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            alert.addAction(UIAlertAction(title: "Take Photo", style: .Default) { _ in
                self.singleton.pickImage(.Camera)
                })
        }
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            alert.addAction(UIAlertAction(title: "Choose from Library", style: .Default) { _ in
                self.singleton.pickImage(.PhotoLibrary)
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
    
    public func show(vc: UIViewController) {
        if iPad {
            let popover = UIPopoverController(contentViewController: vc)
            popover.presentPopoverFromRect(popoverSource.bounds, inView: popoverSource, permittedArrowDirections: .Any, animated: true)
        } else {
            parentVC.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    public func pickImage(type: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        show(picker)
    }
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let controller = PECropViewController()
        controller.delegate = self
        controller.image = image
        controller.keepingCropAspectRatio = true
        controller.cropAspectRatio = 1
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