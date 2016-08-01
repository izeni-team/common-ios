//
//  ViewController.swift
//  IZExample
//
//  Created by Christopher Bryan Henderson on 11/12/15.
//  Copyright © 2015 Bryan Henderson. All rights reserved.
//

import UIKit
import Izeni

class C: UIView, IZCellDynamicHeight {
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func populate(data: Bool) {
        
    }
    
    func cellHeight() -> CGFloat {
        return 0
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOADED")
        print(UIColor(hex: (0xFFFFFF + 1)))
    }
}
