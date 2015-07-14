//
//  UIStoryboardExtenstions.swift
//  Pods
//
//  Created by Taylor Allred on 7/14/15.
//
//

import UIKit

public extension UIStoryboard {
    public convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
    
//    How to use:
//    class func test() {
//        let vc = UIStoryboard(name: "Tickets").instantiateViewControllerWithIdentifier("MyTickets")
//    }
}
