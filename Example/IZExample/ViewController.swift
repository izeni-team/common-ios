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
        
        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
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
        
        containerView.anchorFill(view, offsetLeftBy: -16, offsetRightBy: 16, offsetTopBy: 20, offsetBottomBy: 0)
        

        view2.anchorCenterTo(containerView, offsetBy: CGPoint(x: -100, y: -100))
        view2.anchorSizeTo(CGSize(width: 100, height: 100))
        
        view3.anchorCenterTo(view2, offsetBy: CGPoint(x: 200, y: 0))
        view3.anchorSize = CGSize(width: 100, height: 100)
        
        view4.anchorCenterTo(containerView, offsetBy: CGPoint(x: 0, y: 150))
        view4.anchorSizeTo(300, 100)
        
        view5.anchorCenterXTo(containerView, offsetBy: -125)
        view5.anchorCenterYTo(containerView, offsetBy: 75)
        view5.anchorSizeTo(50, 50)
        
        view6.anchorCenterTo(containerView, offsetBy: CGPoint(x: 125, y: 75), size: CGSize(width: 50, height: 50))
    }
}
