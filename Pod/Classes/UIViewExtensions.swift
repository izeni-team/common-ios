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
    
    // MARK: NSLayoutAnchor
    
    private func enableAnchorContraints() {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // Fill Screen
    
    
    // Center Anchor

    @available(iOS 9.0, *)
    public var centerXAnchor: NSLayoutXAxisAnchor {
        get {
            return centerXAnchor
        }
        set {
            enableAnchorContraints()
            centerXAnchor.constraintEqualToAnchor(NSLayoutXAxisAnchor()).active = true
            centerYAnchor.constraintEqualToAnchor(NSLayoutYAxisAnchor()).active = true
        }
    }
    
    
    // Size Anchor
    @available(iOS 9.0, *)
    public var sizeAnchor: CGSize {
        get {
            var w: CGFloat = 0.0
            var h: CGFloat = 0.0
            for constraint in constraints {
                if constraint.firstAttribute == .Height {
                    h = constraint.constant
                } else if constraint.firstAttribute == .Width {
                    w = constraint.constant
                }
            }
            return CGSizeMake(w, h)
        }
        set {
            enableAnchorContraints()
            widthAnchor.constraintEqualToConstant(newValue.width).active = true
            heightAnchor.constraintEqualToConstant(newValue.height).active = true
        }
    }
    
    // Top / Bottom Anchors
    
    
    
    // Leading / Trailing Anchors
    
    
    
}

// Layout Anchor Helpers

class Anchors {
    
}

@available(iOS 9.0, *)
public struct CenterAnchor {
    var xAnchor: NSLayoutXAxisAnchor!
    var yAnchor: NSLayoutYAxisAnchor!
}






@available(iOS 9.0, *)
public struct SizeAnchor {
    var widthAnchor: NSLayoutXAxisAnchor!
    var heightAnchor: NSLayoutYAxisAnchor!
}
