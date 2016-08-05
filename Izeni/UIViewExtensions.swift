//
//  UIViewExtensions.swift
//  IzeniCommon
//
//  Created by Christopher Henderson on 10/30/14.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    public var presentationLayer: CALayer {
        get {
            return layer.presentationLayer() as! CALayer
        }
    }
    
    public var centerBounds: CGPoint {
        get {
            return CGPointMake(frame.width / 2, frame.height / 2)
        }
    }
    
    public var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    public var right: CGFloat {
        get {
            return x + w
        }
        set {
            x = newValue - w
        }
    }
    
    public var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    public var bottom: CGFloat {
        get {
            return y + h
        }
        set {
            y = newValue - h
        }
    }
    
    public var w: CGFloat {
        get {
            return frame.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    public var h: CGFloat {
        get {
            return frame.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
    
    @IBInspectable public var borderColor: UIColor {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.CGColor
        }
    }
    
    @IBInspectable public var borderThickness: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
    }
}