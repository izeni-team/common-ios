//
//  IZNotification.swift
//  TestIZNotification
//
//  Created by Skyler Smith on 8/12/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import Foundation

public struct IZNotificationCustomizations {
    
    public init() {
    }
    
    //Background
    
    public var backgroundColor = UIColor.clearColor()
    ///Defaults to .Light
    public var blurStyle = UIBlurEffectStyle.Light
    ///Defaults to 60
    public var height: CGFloat = 60
    ///Set the notification to hide after a user tap. Defaults to true
    public var hideNotificationOnTap = true
    
    //Border
    
    ///Defaults to UIColor(hex: 0xb2b2b2)
    public var borderColor = UIColor(hex: 0xb2b2b2)
    ///Defaults to 0.5
    public var borderThickness: CGFloat = 0.5
    
    //Title
    
    ///Defaults to HelveticaNeue-Light, size 20
    public var titleFont = UIFont(name: "HelveticaNeue-Light", size: 20) ?? UIFont(name: "HelveticaNeue", size: 20)!
    ///Defaults to black
    public var titleColor = UIColor.blackColor()
    ///Defaults to 15
    public var titleLabelInset: CGFloat = 15
    //Close Button
    ///Defaults to false
    public var closeButtonHidden = false
    ///Defaults to 40
    public var closeButtonWidth: CGFloat = 40
    ///Defaults to "╳"
    public var closeButtonText = "╳"
    ///Defaults to 20
    public var closeButtonFont = UIFont.systemFontOfSize(20)
    ///Defaults to black
    public var closeButtonColor = UIColor.blackColor()
}

public class IZNotificationView: UIView {
    
    private var appearance: IZNotificationCustomizations!
    
    public var title: String!
    public var onTap: (() -> Void)?
    public var duration: NSTimeInterval!
    
    var animating = false
    
    private var backgroundView : UIVisualEffectView!
    private let titleLabel = UILabel()
    private let closeLabel = UILabel()
    private let closeButton = UIButton()
    
    public init(title: String, duration: NSTimeInterval, customization: IZNotificationCustomizations, onTap: (() -> Void)?) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIApplication.sharedApplication().delegate!.window!!.w, height: customization.height))
        self.appearance = customization
        
        self.title = title
        self.onTap = onTap
        self.duration = duration
        
        let blurView = UIBlurEffect(style: appearance.blurStyle)
        backgroundView = UIVisualEffectView(effect: blurView)
        
        let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurView))
        vibrancyView.frame = backgroundView.bounds
        vibrancyView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        backgroundView.contentView.addSubview(vibrancyView)
        backgroundView.backgroundColor = appearance.backgroundColor
        
        backgroundView.borderColor = appearance.borderColor
        backgroundView.borderThickness = appearance.borderThickness
        backgroundView.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapped"))
        
        titleLabel.text = title
        titleLabel.font = appearance.titleFont
        titleLabel.textColor = appearance.titleColor
        if !appearance.closeButtonHidden {
            closeLabel.text = appearance.closeButtonText
            closeLabel.font = appearance.closeButtonFont
            closeLabel.textColor = appearance.closeButtonColor
            closeButton.addTarget(self, action: "closeButtonTapped", forControlEvents: .TouchUpInside)
            
            backgroundView.contentView.addSubview(closeLabel)
            backgroundView.contentView.addSubview(closeButton)
        }
        backgroundView.contentView.addSubview(titleLabel)
        addSubview(backgroundView)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapped() {
        onTap?()
        if appearance.hideNotificationOnTap {
            IZNotification.singleton.animateOutNotification(self)
        }
    }
    
    func closeButtonTapped() {
        IZNotification.singleton.animateOutNotification(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !animating {
            setupLayout()
        }
    }
    
    func setupLayout() {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.h
        let window = UIApplication.sharedApplication().delegate!.window!!
        self.w = window.w
        backgroundView.frame = CGRect(x: 0, y: 0, width: window.w, height: appearance.height + statusBarHeight)
        if !appearance.closeButtonHidden {
            closeButton.frame = CGRect(x: window.w - appearance.closeButtonWidth, y: statusBarHeight, width: appearance.closeButtonWidth, height: appearance.height)
            closeLabel.frame = CGRect(center: closeButton.center, width: appearance.closeButtonWidth, height: appearance.closeButtonFont.pointSize + 3)
        }
        titleLabel.frame = CGRect(x: appearance.titleLabelInset, centerY: statusBarHeight + appearance.height / 2, width: window.w - (appearance.closeButtonHidden ? 0 : appearance.closeButtonWidth) - appearance.titleLabelInset, height: appearance.titleFont.pointSize + 3)
    }
}

public class IZNotification: NSObject {
    
    public var notificationQueue = [IZNotificationView]()
    private var window = UIApplication.sharedApplication().delegate!.window!!
    private var durationTimer: NSTimer?
    
    public static let singleton = IZNotification()
    
    public class func show(title: String, duration: NSTimeInterval = 3, collapseDuplicates: Bool = true, customization: IZNotificationCustomizations = IZNotificationCustomizations(), onTap: (() -> Void)? = nil) {
        if collapseDuplicates {
            if contains(singleton.notificationQueue.map { $0.title }, title) {
                return
            }
        }
        let IZNView = IZNotificationView(title: title, duration: duration, customization: customization, onTap: onTap)
        singleton.notificationQueue.append(IZNView)
        if singleton.notificationQueue.count == 1 {
            singleton.presentNextNotification()
        }
    }
    
    public class func clearNotificationQueue() {
        singleton.notificationQueue.removeAll(keepCapacity: true)
    }
    
    func presentNextNotification() {
        if notificationQueue.isEmpty {
            return
        }
        let notification = notificationQueue.first!
        window.rootViewController!.view.addSubview(notification)
        animateInNotification(notification)
    }
    
    func animateInNotification(notification: IZNotificationView) {
        notification.animating = true
        notification.setupLayout()
        notification.backgroundView.y = -notification.backgroundView.h
        UIView.animateWithDuration(0.3, animations: { _ in
            notification.backgroundView.y = 0
        }) { success in
            notification.animating = false
            self.durationTimer?.invalidate()
            self.durationTimer = NSTimer.scheduledTimerWithTimeInterval(notification.duration, nonretainedTarget: self, selector: "animateOutNotification:", userInfo: notification)
        }
    }
    
    func animateOutNotification(notification: IZNotificationView) {
        self.durationTimer?.invalidate()
        notification.animating = true
        UIView.animateWithDuration(0.3, animations: { _ in
            notification.backgroundView.y = -notification.backgroundView.h
        }) { success in
            notification.animating = false
            self.notificationQueue.removeAtIndex(0)
            notification.removeFromSuperview()
            self.presentNextNotification()
        }
    }
}