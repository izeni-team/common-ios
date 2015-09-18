//
//  UIImageExtensions.swift
//  IzeniCommon
//
//  Created by Taylor Allred on 6/1/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import UIKit

typealias _CIImage = CIImage

public extension UIImage {
    public func resizeImage(size: Float, callback: (image: UIImage) -> Void) {
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        
        dispatch_async(backgroundQueue, {
            // Size is the smaller of height and width
            // The idea here is that we'll crop off the side that is too long by using
            // imageView.contentMode = .ScaleAspectFill
            let scale: Float = size / Float(min(self.size.height, self.size.width))
            let image = _CIImage(CGImage: self.CGImage!)
            
            let filter = CIFilter(name: "CILanczosScaleTransform")!
            filter.setValue(image, forKey: "inputImage")
            filter.setValue(scale, forKey: "inputScale")
            filter.setValue(1, forKey: "inputAspectRatio")
            
            
            
            let outputImage = filter.valueForKey("outputImage") as! _CIImage
            let context = CIContext(options: nil)
            let scaledImage = UIImage(CGImage: context.createCGImage(outputImage, fromRect: outputImage.extent))
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                callback(image: scaledImage)
            })
        })
    }
}