//
//  SpinnerVC.swift
//  Pods
//
//  Created by Skyler Smith on 8/7/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import UIKit

class SpinnerVC: UIViewController {
    
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(spinner)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spinner.center = view.centerBounds
    }
    
    func presentOnVC(vc: UIViewController, completion: (() -> Void)) {
        self.modalPresentationStyle = .OverCurrentContext
        self.modalTransitionStyle = .CrossDissolve
        view.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.6)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        vc.presentViewController(self, animated: true, completion: completion)
    }
    
    func dismissFromVC(vc: UIViewController, completion: (() -> Void)) {
        if vc.presentedViewController === self {
            vc.dismissViewControllerAnimated(true, completion: completion)
        } else {
            completion()
        }
    }
    
}
