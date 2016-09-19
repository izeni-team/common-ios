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
            return layer.presentation()!
        }
    }
    
    public var centerBounds: CGPoint {
        get {
            return CGPoint(x: frame.width / 2, y: frame.height / 2)
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
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
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
    fileprivate struct SizeAnchor {
        var widthAnchor: NSLayoutXAxisAnchor!
        var heightAnchor: NSLayoutYAxisAnchor!
    }
    
    @available(iOS 9.0, *)
    struct CenterAnchor {
        var centerXAnchor: NSLayoutXAxisAnchor!
        var centerYAnchor: NSLayoutYAxisAnchor!
    }
    
    fileprivate func enableAnchorContraints() {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // Fill Screen
    
    @available(iOS 9.0, *)
    public func anchorFill(view: UIView) {
        let margins = view.layoutMarginsGuide
        anchorLeadTo(anchor: margins.leadingAnchor)
        anchorTrailTo(anchor: margins.trailingAnchor)
        anchorTopTo(anchor: margins.topAnchor)
        anchorBottomTo(anchor: margins.bottomAnchor)
    }
    
    @available(iOS 9.0, *)
    public func anchorFill(view: UIView, offsetBy: CGSize) {
        let margins = view.layoutMarginsGuide
        anchorLeadTo(anchor: margins.leadingAnchor, offsetBy: offsetBy.width)
        anchorTrailTo(anchor: margins.trailingAnchor, offsetBy: -offsetBy.width)
        anchorTopTo(anchor: margins.topAnchor, offsetBy: offsetBy.height)
        anchorBottomTo(anchor: margins.bottomAnchor, offsetBy: -offsetBy.height)
    }
    
    @available(iOS 9.0, *)
    public func anchorFill(view: UIView, offsetLeftBy: CGFloat = 0, offsetRightBy: CGFloat = 0, offsetTopBy: CGFloat = 0, offsetBottomBy: CGFloat = 0) {
        let margins = view.layoutMarginsGuide
        anchorLeadTo(anchor: margins.leadingAnchor, offsetBy: offsetLeftBy)
        anchorTrailTo(anchor: margins.trailingAnchor, offsetBy: offsetRightBy)
        anchorTopTo(anchor: margins.topAnchor, offsetBy: offsetTopBy)
        anchorBottomTo(anchor: margins.bottomAnchor, offsetBy: offsetBottomBy)
    }
    
    // Center Anchor

    @available(iOS 9.0, *)
    public var centerAnchor: CenterAnchor {
        get {
            return CenterAnchor(centerXAnchor: centerXAnchor, centerYAnchor: centerYAnchor)
        }
        set {
            enableAnchorContraints()
            centerXAnchor.constraint(equalTo: newValue.centerXAnchor).isActive = true
            centerYAnchor.constraint(equalTo: newValue.centerYAnchor).isActive = true
        }
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterTo(view: UIView) {
        enableAnchorContraints()
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterTo(view: UIView, offsetBy: CGPoint) {
        enableAnchorContraints()
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offsetBy.x).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offsetBy.y).isActive = true
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterTo(view: UIView, size: CGSize) {
        enableAnchorContraints()
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        anchorSize = size
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterTo(view: UIView, offsetBy: CGPoint, size: CGSize) {
        enableAnchorContraints()
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offsetBy.x).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offsetBy.y).isActive = true
        anchorSize = size
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterXTo(view: UIView) {
        enableAnchorContraints()
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterXTo(view: UIView, offsetBy: CGFloat) {
        enableAnchorContraints()
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offsetBy).isActive = true
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterYTo(view: UIView) {
        enableAnchorContraints()
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @available(iOS 9.0, *)
    public func anchorCenterYTo(view: UIView, offsetBy: CGFloat) {
        enableAnchorContraints()
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offsetBy).isActive = true
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
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    @available(iOS 9.0, *)
    public func anchorSizeTo(size: CGSize) {
        anchorSize = size
    }
    
    @available(iOS 9.0, *)
    public func anchorSizeTo(_ w: CGFloat, _ h: CGFloat) {
        anchorSize = CGSize(width: w, height: h)
    }
    
    // Top / Bottom Anchors
    
    @available(iOS 9.0, *)
    public func anchorTopTo(anchor: NSLayoutYAxisAnchor) {
        enableAnchorContraints()
        topAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    @available(iOS 9.0, *)
    public func anchorTopTo(anchor: NSLayoutYAxisAnchor, offsetBy: CGFloat) {
        enableAnchorContraints()
        topAnchor.constraint(equalTo: anchor, constant: offsetBy).isActive = true
    }
    
    @available(iOS 9.0, *)
    public func anchorBottomTo(anchor: NSLayoutYAxisAnchor) {
        enableAnchorContraints()
        bottomAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    @available(iOS 9.0, *)
    public func anchorBottomTo(anchor: NSLayoutYAxisAnchor, offsetBy: CGFloat) {
        enableAnchorContraints()
        bottomAnchor.constraint(equalTo: anchor, constant: offsetBy).isActive = true
    }
    
    // Leading / Trailing Anchors
    
    @available(iOS 9.0, *)
    public func anchorLeadTo(anchor: NSLayoutXAxisAnchor) {
        enableAnchorContraints()
        leadingAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    @available(iOS 9.0, *)
    public func anchorLeadTo(anchor: NSLayoutXAxisAnchor, offsetBy: CGFloat) {
        enableAnchorContraints()
        leadingAnchor.constraint(equalTo: anchor, constant: offsetBy).isActive = true
    }
    
    @available(iOS 9.0, *)
    public func anchorTrailTo(anchor: NSLayoutXAxisAnchor) {
        enableAnchorContraints()
        trailingAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    @available(iOS 9.0, *)
    public func anchorTrailTo(anchor: NSLayoutXAxisAnchor, offsetBy: CGFloat) {
        enableAnchorContraints()
        trailingAnchor.constraint(equalTo: anchor, constant: offsetBy).isActive = true
    }
    
}
