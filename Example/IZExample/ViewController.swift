//
//  ViewController.swift
//  IZExample
//
//  Created by Christopher Bryan Henderson on 11/12/15.
//  Copyright © 2015 Bryan Henderson. All rights reserved.
//

import UIKit
import Izeni

class ViewController: UIViewController, IZImagePickerDelegate {
    @IBOutlet var openImagePickerButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBAction func openImagePicker() {
        let picker = IZImagePicker.instance
        if picker.isIpad {
            picker.setPopoverSourceForIPad(openImagePickerButton)
        }
        picker.pickImage(delegate: self, vc: self)
        
        
//                ImagePicker.pickImage(from: self, popoverSource: openImagePickerButton, delegate: self)
    }
    
    func imagePicked(image: UIImage) {
        backgroundImage.image = image
    }
    
    func imagePickCancelled() {
        print("Cancelled image pick")
    }
}
