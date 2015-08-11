//
//  IzeniResizingCellExtension.swift
//  Izeni
//
//  Created by Skyler Smith on 7/23/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    /**
    This function is best called within heightForRowAtIndexPath as described on
    http://stackoverflow.com/questions/5254723/how-to-obtain-the-uitableviewcell-within-heightforrowatindexpath
    
    :returns: The recommended height of the cell (Finds the lowest point in any view contained in the cell)
    */
    public func calculateHeight() -> CGFloat {
        let views = self.contentView.subviews as! [UIView]
        var bottom: CGFloat = 0
        for view in views {
            let viewBottom = view.frame.origin.y + view.frame.height
            if viewBottom > bottom {
                bottom = viewBottom
            }
        }
        return bottom
    }
}
