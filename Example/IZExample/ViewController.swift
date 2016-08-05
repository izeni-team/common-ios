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
        
        let view2 = UIView(frame: CGRectMake(0, 0, 300, 300))
        containerView.addSubview(view2)
        view2.backgroundColor = .yellow
        
        let view3 = UIView()
        containerView.addSubview(view3)
        view3.backgroundColor = .yellow
        
        let view4 = UIView()
        containerView.addSubview(view4)
        view4.backgroundColor = .yellow
        
        let view5 = UIView()
        containerView.addSubview(view5)
        view5.backgroundColor = .yellow
        
        let view6 = UIView()
        containerView.addSubview(view6)
        view6.backgroundColor = .yellow
        
        containerView.anchorFill(view: view, offsetLeftBy: -16, offsetRightBy: 16, offsetTopBy: 20, offsetBottomBy: 0)

        view2.anchorCenterTo(view: containerView, offsetBy: CGPointMake(-100, -100))
        view2.anchorSizeTo(size: CGSizeMake(100, 100))
        
        view3.anchorCenterTo(view: view2, offsetBy: CGPointMake(200, 0))
        view3.anchorSize = CGSizeMake(100, 100)
        
        view4.anchorCenterTo(view: containerView, offsetBy: CGPointMake(0, 150))
        view4.anchorSizeTo(300, 100)
        
        view5.anchorCenterXTo(view: containerView, offsetBy: -125)
        view5.anchorCenterYTo(view: containerView, offsetBy: 75)
        view5.anchorSizeTo(50, 50)
        
        view6.anchorCenterTo(view: containerView, offsetBy: CGPointMake(125, 75), size: CGSizeMake(50, 50))
    }
}
