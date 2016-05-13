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

class IZTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
    }
}

class IZCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
    }
}

class IZCellView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
    }
}

protocol IZCellProtocol: class {
    associatedtype T
    static func calculateHeight(data: T, width: CGFloat) -> CGFloat
    func setup()
    func populate(data: T)
    func layoutSubviews()
}

protocol IZCellDynamicHeightProtocol: IZCellProtocol {
    init(frame: CGRect)
    var frame: CGRect { get set }
    func bottommostSubviewMaxY() -> CGFloat
    func cellHeight() -> CGFloat
}

private var cache = [ObjectIdentifier: AnyObject]()

extension IZCellDynamicHeightProtocol {
    static func calculateHeight(data: T, width: CGFloat) -> CGFloat {
        let view: Self
        if let cached = cache[ObjectIdentifier(self)] {
            view = cached as! Self
            view.frame.size.width = width
        } else {
            view = Self(frame: CGRect(x: 0, y: 0, width: width, height: 600))
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
        for subview in view.subviews.filter({ !$0.hidden && $0.alpha > 0 }) {
            maxY = max(CGRectGetMaxY(subview.frame), maxY)
        }
        return maxY
    }
}

extension UIView {
    func showMaterialShadow(dpDepth dpDepth: Int) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSizeMake(0, CGFloat(dpDepth))
        layer.shadowRadius = CGFloat(dpDepth) / 2
        layer.shadowOpacity = 0.28
    }
}