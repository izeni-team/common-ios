//
//  ViewController.swift
//  IZExample
//
//  Created by Christopher Bryan Henderson on 11/12/15.
//  Copyright © 2015 Bryan Henderson. All rights reserved.
//

import UIKit
import Izeni

class C: UIView, IZCellDynamicHeight {
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func populate(data: Bool) {
        
    }
    
    func cellHeight() -> CGFloat {
        return 0
    }
}

class ViewController: UIViewController, IZImagePickerDelegate {
    @IBOutlet var openImagePickerButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBAction func openImagePicker() {
//        let picker = IZImagePicker.instance
//        if picker.isIpad {
//            picker.setPopoverSourceForIPad(openImagePickerButton)
//        }
//        picker.setCameraEnabled(false)
//        picker.setLibraryEnabled(false)
//        picker.pickImage(delegate: self, vc: self)
//        
//        
        IZImagePicker.pickImage(delegate: self, vc: self, useCamera: true, useLibrary: true, preferFrontCamera: true, iPadPopoverSource: openImagePickerButton, aspectRatio: 1)
        
        
//                ImagePicker.pickImage(from: self, popoverSource: openImagePickerButton, delegate: self)
    }
    
    @IBAction func showInfiniteNotification() {
        IZNotification.showUnified("Title", subtitle: "Subtitle", data: [:], duration: NSTimeInterval.infinity, customizations: nil)
    }
    
    func imagePicked(image: UIImage) {
        backgroundImage.image = image
    }
    
    func imagePickCancelled() {
        print("Cancelled image pick")
    }
}
