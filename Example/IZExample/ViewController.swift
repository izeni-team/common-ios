//
//  ViewController.swift
//  IZExample
//
//  Created by Christopher Bryan Henderson on 11/12/15.
//  Copyright © 2015 Bryan Henderson. All rights reserved.
//

import UIKit
import Izeni

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        self.containerView.backgroundColor = .black
        
        let view2 = UIView()
        containerView.addSubview(view2)
        view2.backgroundColor = .cyan
        
        view2.sizeAnchor = CGSizeMake(50, 50)
        let sizeAnchor = view2.sizeAnchor
        print(sizeAnchor)
        
        view2.centerAnchor = CGPointMake(100, 100)
        
        
    }
}
