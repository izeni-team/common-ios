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
    public func resizeImage(_ size: Float, callback: @escaping (_ image: UIImage) -> Void) {
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        
        backgroundQueue.async(execute: {
            // Size is the smaller of height and width
            // The idea here is that we'll crop off the side that is too long by using
            // imageView.contentMode = .ScaleAspectFill
            let scale: Float = size / Float(min(self.size.height, self.size.width))
            let image = _CIImage(cgImage: self.cgImage!)
            
            let filter = CIFilter(name: "CILanczosScaleTransform")!
            filter.setValue(image, forKey: "inputImage")
            filter.setValue(scale, forKey: "inputScale")
            filter.setValue(1, forKey: "inputAspectRatio")
            
            
            
            let outputImage = filter.value(forKey: "outputImage") as! _CIImage
            let context = CIContext(options: nil)
            let scaledImage = UIImage(cgImage: context.createCGImage(outputImage, from: outputImage.extent)!)
            
            DispatchQueue.main.async(execute: { () -> Void in
                callback(scaledImage)
            })
        })
    }
}
