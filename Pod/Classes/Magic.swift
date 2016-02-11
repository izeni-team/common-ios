//
//  Magic.swift
//  IzeniCommon
//
//  Created by Christopher Henderson on 10/30/14.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import Foundation
import UIKit

public extension CGRect {
    public init(centerX: CGFloat, centerY: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(x: centerX - width / 2, y: centerY - height / 2, width: width, height: height)
    }
    
    public init(centerX: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(x: centerX - width / 2, y: y, width: width, height: height)
    }
    
    public init(x: CGFloat, centerY: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(x: x, y: centerY - height / 2, width: width, height: height)
    }
    
    public init(x: CGFloat, centerY: CGFloat, right: CGFloat, height: CGFloat) {
        self.init(x: x, y: centerY - height / 2, width: right - x, height: height)
    }
    
    public init(center: CGPoint, width: CGFloat, height: CGFloat) {
        self.init(centerX: center.x, centerY: center.y, width: width, height: height)
    }
    
    public init(x: CGFloat, y: CGFloat, right: CGFloat, height: CGFloat) {
        self.init(x: x, y: y, width: right - x, height: height)
    }
    
    public init(x: CGFloat, y: CGFloat, right: CGFloat, bottom: CGFloat) {
        self.init(x: x, y: y, width: right - x, height: bottom - y)
    }
    
    public init(x: CGFloat, bottom: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(x: x, y: bottom - height, width: width, height: height)
    }
    
    public var x: CGFloat {
        get {
            return origin.x
        }
        set {
            origin.x = newValue
        }
    }
    
    public var y: CGFloat {
        get {
            return origin.y
        }
        set {
            origin.y = newValue
        }
    }
    
    public var w: CGFloat {
        get {
            return width
        }
        set {
            size.width = newValue
        }
    }
    
    public var h: CGFloat {
        get {
            return height
        }
        set {
            size.height = newValue
        }
    }
    
    public var bottom: CGFloat {
        get {
            return y + height
        }
        set {
            y = newValue - height
        }
    }
    
    public var right: CGFloat {
        get {
            return x + width
        }
        set {
            x = newValue - width
        }
    }
}

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

    private class BorderView: UIView {
        private override func layoutSubviews() {
            if let tmp = superview {
                w = tmp.w
            }
        }
    }
    
    private var border: BorderView {
        let tag = 821369
        if let view = self.viewWithTag(tag) as? BorderView {
            return view
        } else {
            let view = BorderView(frame: CGRectZero)
            view.tag = tag
            addSubview(view)
            return view
        }
    }
    
    @IBInspectable public var bottomBorderColor: UIColor {
        get {
            return border.backgroundColor!
        }
        set {
            border.backgroundColor = newValue
        }
    }
    
    @IBInspectable public var bottomBorderThickness: CGFloat {
        get {
            return border.h
        }
        set {
            border.bottom = h
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

public extension String {
    public var range: Range<String.Index> {
        return Range<String.Index>(start: startIndex, end: endIndex)
    }
}

public extension UIColor {
    private class func rgbFromHex(hex: UInt32) -> [CGFloat] {
        return [
            CGFloat((hex >> 16) & 0xFF) / 255,
            CGFloat((hex >> 8) & 0xFF) / 255,
            CGFloat(hex & 0xFF) / 255,
        ]
    }
    
    convenience init(hex: UInt32) {
        let rgb = UIColor.rgbFromHex(hex)
        self.init(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1)
    }
    
    convenience init(hexString: String) {
        let filteredString = hexString.stringByReplacingOccurrencesOfString("#", withString: "").stringByReplacingOccurrencesOfString("0x", withString: "")
        let hexNum = UInt32(filteredString, radix: 16)
        let rgb = UIColor.rgbFromHex(hexNum!)
        self.init(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1)
    }
}