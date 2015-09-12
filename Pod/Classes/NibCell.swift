//
//  NibCell.swift
//  Izeni
//
//  Created by Christopher Bryan Henderson on 9/12/15.
//  Copyright (c) 2015 Izeni. All rights reserved.
//

import UIKit

class NibCell: UITableViewCell {
    var nib: String {
        fatalError("Must be overridden")
    }
    var nibView: UIView!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func setup() {
        nibView = NSBundle.mainBundle().loadNibNamed(nib, owner: self, options: nil).first as! UIView
        contentView.addSubview(nibView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nibView.frame = bounds
    }
}
