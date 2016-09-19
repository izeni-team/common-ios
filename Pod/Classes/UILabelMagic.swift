//
//  UILabelMagic.swift
//  IzeniCommon
//
//  Created by Jacob Ovard on 3/20/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import UIKit

public extension UILabel {
    
    public func heightToFit() {
        let text = (self.text ?? "") as NSString
        let attributes = [
            NSFontAttributeName: self.font
        ]
        let constraints = CGSize(width: self.w, height: CGFloat.greatestFiniteMagnitude)
        let size = text.boundingRect(with: constraints, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        self.h = size.height
    }
    
}
