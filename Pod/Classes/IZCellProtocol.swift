//
//  IZCellProtocol.swift
//  IZCommon
//
//  Created by Christopher Bryan Henderson on 5/12/16.
//  Copyright © 2016 Izeni. All rights reserved.
//
//  Released under a MIT license: http://opensource.org/licenses/MIT
//

import UIKit

public protocol IZCellDynamicHeight: class {
    associatedtype T
    func populate(_ data: T)
    
    // Height calculation
    static func calculateHeight(_ data: T, width: CGFloat) -> CGFloat // Has default implementation
    var frame: CGRect { get set } // Should be provided by UIView
    init(frame: CGRect) // Should be provided by UIView
    func layoutSubviews() // Should be provided by UIView
    func cellHeight() -> CGFloat // You should implement this
    func bottommostSubviewMaxY() -> CGFloat // Has default implementation. Useful when used in cellHeight()
}

public protocol IZCellStaticHeight: class {
    associatedtype T
    static var height: CGFloat { get }
    func populate(_ data: T)
}

private var cache = [ObjectIdentifier: AnyObject]()

public extension IZCellDynamicHeight {
    static func calculateHeight(_ data: T, width: CGFloat) -> CGFloat {
        let view: Self
        if let cached = cache[ObjectIdentifier(self)] {
            view = cached as! Self
            view.frame.size.width = width
        } else {
            view = Self(frame: CGRect(x: 0, y: 0, width: width, height: 0))
            cache[ObjectIdentifier(self)] = view
        }
        view.populate(data)
        view.layoutSubviews()
        return view.cellHeight()
    }
    
    func bottommostSubviewMaxY() -> CGFloat {
        let view: UIView
        if let cell = self as? UITableViewCell {
            view = cell.contentView
        } else if let cell = self as? UICollectionViewCell {
            view = cell.contentView
        } else if let v = self as? UIView {
            view = v
        } else {
            return 0
        }
        
        var maxY: CGFloat = 0
        for subview in view.subviews.filter({ !$0.isHidden && $0.alpha > 0 }) {
            maxY = max(subview.frame.maxY, maxY)
        }
        return maxY
    }
}

public extension UIView {
    func showMaterialShadow(_ dpDepth: Int) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: CGFloat(dpDepth))
        layer.shadowRadius = CGFloat(dpDepth) / 2
        layer.shadowOpacity = 0.28
    }
}
