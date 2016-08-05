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
    
    @available(iOS 9.0, *)
    private struct SizeAnchor {
        var widthAnchor: NSLayoutXAxisAnchor!
        var heightAnchor: NSLayoutYAxisAnchor!
    }
    
    @available(iOS 9.0, *)
    struct CenterAnchor {
        var centerXAnchor: NSLayoutXAxisAnchor!
        var centerYAnchor: NSLayoutYAxisAnchor!
    }
    
    private func enableAnchorContraints() {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // Fill Screen
    
    @available(iOS 9.0, *)
    public func anchorFill(view view: UIView) {
        let margins = view.layoutMarginsGuide
        anchorLeadTo(margins.leadingAnchor)
        anchorTrailTo(margins.trailingAnchor)
        anchorTopTo(margins.topAnchor)
        anchorBottomTo(margins.bottomAnchor)
    }
    
    @available(iOS 9.0, *)
    public func anchorFill(view view: UIView, offsetBy: CGSize) {
        let margins = view.layoutMarginsGuide
        anchorLeadTo(margins.leadingAnchor, offsetBy: offsetBy.width)
        anchorTrailTo(margins.trailingAnchor, offsetBy: -offsetBy.width)
        anchorTopTo(margins.topAnchor, offsetBy: offsetBy.height)
        anchorBottomTo(margins.bottomAnchor, offsetBy: -offsetBy.height)
    }
    
    @available(iOS 9.0, *)
    public func anchorFill(view view: UIView, offsetLeftBy: CGFloat = 0, offsetRightBy: CGFloat = 0, offsetTopBy: CGFloat = 0, offsetBottomBy: CGFloat = 0) {
        let margins = view.layoutMarginsGuide
        anchorLeadTo(margins.leadingAnchor, offsetBy: offsetLeftBy)
        anchorTrailTo(margins.trailingAnchor, offsetBy: offsetRightBy)
        anchorTopTo(margins.topAnchor, offsetBy: offsetTopBy)
        anchorBottomTo(margins.bottomAnchor, offsetBy: offsetBottomBy)
    }
    
    // Center Anchor

    @available(iOS 9.0, *)
    public var centerAnchor: CenterAnchor {
        get {
            return CenterAnchor(centerXAnchor: centerXAnchor, centerYAnchor: centerYAnchor)
        }
        set {
            enableAnchorContraints()
            centerXAnchor.constraintEqualToAnchor(newValue.centerXAnchor).active = true
            centerYAnchor.constraintEqualToAnchor(newValue.centerYAnchor).active = true
        }
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterTo(view view: UIView) {
        enableAnchorContraints()
        centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterTo(view view: UIView, offsetBy: CGPoint) {
        enableAnchorContraints()
        centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: offsetBy.x).active = true
        centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: offsetBy.y).active = true
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterTo(view view: UIView, size: CGSize) {
        enableAnchorContraints()
        centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        anchorSize = size
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterTo(view view: UIView, offsetBy: CGPoint, size: CGSize) {
        enableAnchorContraints()
        centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: offsetBy.x).active = true
        centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: offsetBy.y).active = true
        anchorSize = size
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterXTo(view view: UIView) {
        enableAnchorContraints()
        centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterXTo(view view: UIView, offsetBy: CGFloat) {
        enableAnchorContraints()
        centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: offsetBy).active = true
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterYTo(view view: UIView) {
        enableAnchorContraints()
        centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterYTo(view view: UIView, offsetBy: CGFloat) {
        enableAnchorContraints()
        centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: offsetBy).active = true
    }
    
    
    // Size Anchor
    @available(iOS 9.0, *)
    @IBInspectable public var anchorSize: CGSize {
        get {
            return size
        }
        set {
            enableAnchorContraints()
            self.size = newValue
            widthAnchor.constraintEqualToConstant(size.width).active = true
            heightAnchor.constraintEqualToConstant(size.height).active = true
        }
    }
    
    @available(iOS 9.0, *)
    public func anchorSizeTo(size size: CGSize) {
        anchorSize = size
    }
    
    @available(iOS 9.0, *)
    public func anchorSizeTo(_ w: CGFloat, _ h: CGFloat) {
        anchorSize = CGSizeMake(w, h)
    }
    
    // Top / Bottom Anchors
    
    @available(iOS 9.0, *)
    public func anchorTopTo(anchor: NSLayoutYAxisAnchor) {
        enableAnchorContraints()
        topAnchor.constraintEqualToAnchor(anchor).active = true
    }
    
    @available(iOS 9.0, *)
    public func anchorTopTo(anchor: NSLayoutYAxisAnchor, offsetBy: CGFloat) {
        enableAnchorContraints()
        topAnchor.constraintEqualToAnchor(anchor, constant: offsetBy).active = true
    }
    
    @available(iOS 9.0, *)
    public func anchorBottomTo(anchor: NSLayoutYAxisAnchor) {
        enableAnchorContraints()
        bottomAnchor.constraintEqualToAnchor(anchor).active = true
    }
    
    @available(iOS 9.0, *)
    public func anchorBottomTo(anchor: NSLayoutYAxisAnchor, offsetBy: CGFloat) {
        enableAnchorContraints()
        bottomAnchor.constraintEqualToAnchor(anchor, constant: offsetBy).active = true
    }
    
    // Leading / Trailing Anchors
    
    @available(iOS 9.0, *)
    public func anchorLeadTo(anchor: NSLayoutXAxisAnchor) {
        enableAnchorContraints()
        leadingAnchor.constraintEqualToAnchor(anchor).active = true
    }
    
    @available(iOS 9.0, *)
    public func anchorLeadTo(anchor: NSLayoutXAxisAnchor, offsetBy: CGFloat) {
        enableAnchorContraints()
        leadingAnchor.constraintEqualToAnchor(anchor, constant: offsetBy).active = true
    }
    
    @available(iOS 9.0, *)
    public func anchorTrailTo(anchor: NSLayoutXAxisAnchor) {
        enableAnchorContraints()
        trailingAnchor.constraintEqualToAnchor(anchor).active = true
    }
    
    @available(iOS 9.0, *)
    public func anchorTrailTo(anchor: NSLayoutXAxisAnchor, offsetBy: CGFloat) {
        enableAnchorContraints()
        trailingAnchor.constraintEqualToAnchor(anchor, constant: offsetBy).active = true
    }
    
}