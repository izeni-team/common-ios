//
//  UIColorExtensions.swift
//  Pods
//
//  Created by Taylor Allred on 8/1/16.
//
//

import UIKit

public extension UIColor {
    
    fileprivate class func rgbFromHex(_ hex: UInt32) -> [CGFloat] {
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
        var filtered = hexString.replacingOccurrences(of: "#", with: "")
        filtered = filtered.replacingOccurrences(of: "0x", with: "")
        filtered = filtered.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)
        guard let hexNum = UInt32(filtered, radix: 16) , filtered.characters.count == 6 else {
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
}
