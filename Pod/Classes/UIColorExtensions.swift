//
//  UIColorExtensions.swift
//  Pods
//
//  Created by Taylor Allred on 8/1/16.
//
//

import UIKit

public extension UIColor {
    
    private class func rgbFromHex(hex: UInt32) -> [CGFloat] {
        return [
            CGFloat((hex >> 16) & 0xFF) / 255,
            CGFloat((hex >> 8) & 0xFF) / 255,
            CGFloat(hex & 0xFF) / 255,
        ]
    }
    
    // TODO: Make this a failable initializer after https://bugs.swift.org/browse/SR-704 is fixed.
    
    public convenience init?(hex: UInt32) {
        guard hex == hex & 0xFFFFFF else {
            return nil
        }
        let rgb = UIColor.rgbFromHex(hex)
        self.init(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1)
    }
    
    public convenience init?(hexString: String) {
        var filtered = hexString.stringByReplacingOccurrencesOfString("#", withString: "")
        filtered = filtered.stringByReplacingOccurrencesOfString("0x", withString: "")
        filtered = filtered.stringByReplacingOccurrencesOfString("\\s+", withString: "", options: .RegularExpressionSearch)
        guard let hexNum = UInt32(filtered, radix: 16) where filtered.characters.count == 6 else {
            return nil
        }
        let rgb = UIColor.rgbFromHex(hexNum)
        self.init(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1)
    }
    
    public func hexString() -> String {
        let color = UIKit.CIColor(color: self)
        let redValue = String(format: "%.2x", UInt(color.red * CGFloat(255.0)))
        let blueValue = String(format: "%.2x", UInt(color.blue * CGFloat(255.0)))
        let greenValue = String(format: "%.2x", UInt(color.green * CGFloat(255.0)))
        return redValue + greenValue + blueValue
    }
    
    public class var black: UIColor {
        get {
            return .blackColor()
        }
    }
    
    public class var darkGray: UIColor {
        get {
            return .darkGrayColor()
        }
    }
    
    public class var lightGray: UIColor {
        get {
            return .lightGrayColor()
        }
    }
    
    public class var white: UIColor {
        get {
            return .whiteColor()
        }
    }
    
    public class var gray: UIColor {
        get {
            return .grayColor()
        }
    }
    
    
    // Cannot use red, green, blue for shorthand
//    public class var red: UIColor {
//        get {
//            return .redColor()
//        }
//    }
//    
//    public class var green: UIColor {
//        get {
//            return .greenColor()
//        }
//    }
//    
//    public class var blue: UIColor {
//        get {
//            return .blueColor()
//        }
//    }
    
    public class var cyan: UIColor {
        get {
            return .cyanColor()
        }
    }
    
    public class var yellow: UIColor {
        get {
            return .yellowColor()
        }
    }
    
    public class var magenta: UIColor {
        get {
            return .magentaColor()
        }
    }
    
    public class var orange: UIColor {
        get {
            return .orangeColor()
        }
    }
    
    public class var purple: UIColor {
        get {
            return .purpleColor()
        }
    }
    
    public class var brown: UIColor {
        get {
            return .brownColor()
        }
    }
    
    public class var clear: UIColor {
        get {
            return .clearColor()
        }
    }
    
    
    
}