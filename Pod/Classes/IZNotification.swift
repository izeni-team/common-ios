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
    
    // Behavior
    public var hideNotificationOnTap = true
    public var hideNotificationOnSwipeUp = true
    public var createUILocalNotificationIfInBackground = true
    public var defaultDuration = NSTimeInterval(5)
    
    // Background
    
    public var backgroundColor = UIColor.clearColor()
    public var blurStyle = UIBlurEffectStyle.Light
    
    // Separator
    
    public var separatorColor = UIColor(white: 0.7, alpha: 1)
    public var separatorThickness: CGFloat = 0.5
    
    // Title/Subtitle
    
    public var titleFont = UIFont.systemFontOfSize(20)
    public var titleColor = UIColor.blackColor()
    public var titleXInset: CGFloat = 15
    public var titleRightInset: CGFloat = 15
    public var titleYInset: CGFloat = 12
    public var titleBottomInset: CGFloat = 15
    public var subtitleFont = UIFont.systemFontOfSize(15)
    public var subtitleColor = UIColor(white: 0.15, alpha: 1)
    public var subtitleXInset: CGFloat = 15
    public var subtitleRightInset: CGFloat = 15
    public var subtitleYInset: CGFloat = 12
    public var subtitleBottomInset: CGFloat = 15
    public var titleAndSubtitleSpacing: CGFloat = 3
    public var numberOfLinesInTitle = 1
    public var numberOfLinesInSubtitle = 2
    
    // Close Button
    
    public var closeButtonHidden = false
    public var closeButtonWidth: CGFloat = 44
    public var closeButtonText = "╳" // TODO: Draw natively, don't use font or assets
    public var closeButtonFont = UIFont.systemFontOfSize(20)
    public var closeButtonColor = UIColor.blackColor()
}

public class IZNotificationView: UIView {
    public var title: String?
    public var subtitle: String?
    public var onTap: (() -> Void)?
    public var duration: NSTimeInterval
    
    public var customizations: IZNotificationCustomizations!
    public var animating = false
    public var backgroundView : UIVisualEffectView!
    public let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    public let subtitleLabel = UILabel()
    public let closeButton = UIButton()
    public let separator = UIView()
    
    public init(var title: String?, var subtitle: String?, duration: NSTimeInterval, customizations: IZNotificationCustomizations, onTap: (() -> Void)? = nil) {
        
        // Check if we're missing a title and subtitle
        let somethingToDisplay = (title == nil || !title!.isEmpty) && (subtitle == nil || !subtitle!.isEmpty)
        assert(somethingToDisplay, "Both title and subtitle are either nil or empty. Nothing to display.")
        if !somethingToDisplay { // Will not get here in debug builds, but will in release builds.
            title = "Notification"
            subtitle = onTap != nil ? "Tap to view." : nil
        }
        
        self.duration = duration
        super.init(frame: CGRectZero)
        self.customizations = customizations
        
        self.title = title
        self.subtitle = subtitle
        self.onTap = onTap
        
        let blurView = UIBlurEffect(style: customizations.blurStyle)
        backgroundView = UIVisualEffectView(effect: blurView)
        
        let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurView))
        vibrancyView.frame = backgroundView.bounds
        vibrancyView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        backgroundView.contentView.addSubview(vibrancyView)
        backgroundView.backgroundColor = customizations.backgroundColor
        
        separator.backgroundColor = customizations.separatorColor
        backgroundView.contentView.addSubview(separator)
        
        if title != nil && !title!.isEmpty {
            titleLabel.text = title
            titleLabel.font = customizations.titleFont
            titleLabel.textColor = customizations.titleColor
            backgroundView.contentView.addSubview(titleLabel)
        }
        
        if subtitle != nil && !subtitle!.isEmpty {
            subtitleLabel.text = subtitle
            subtitleLabel.font = customizations.subtitleFont
            subtitleLabel.textColor = customizations.subtitleColor
            backgroundView.contentView.addSubview(subtitleLabel)
        }
        
        if !customizations.closeButtonHidden {
            closeButton.setTitle(customizations.closeButtonText, forState: [])
            closeButton.titleLabel!.font = customizations.closeButtonFont
            closeButton.setTitleColor(customizations.closeButtonColor, forState: [])
            closeButton.addTarget(self, action: "closeButtonTapped", forControlEvents: .TouchUpInside)
            backgroundView.contentView.addSubview(closeButton)
        }
        addSubview(backgroundView)
        
        if customizations.hideNotificationOnTap {
            let tap = UITapGestureRecognizer(target: self, action: "tapped")
            backgroundView.contentView.addGestureRecognizer(tap)
        }
        
        if customizations.hideNotificationOnSwipeUp {
            let swipeAwayGesture = UISwipeGestureRecognizer(target: self, action: "closeButtonTapped")
            swipeAwayGesture.direction = .Up
            backgroundView.contentView.addGestureRecognizer(swipeAwayGesture)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func tapped() {
        if customizations.hideNotificationOnTap {
            IZNotification.singleton.animateOutNotificationView(self)
        }
        onTap?()
    }
    
    public func closeButtonTapped() {
        IZNotification.singleton.animateOutNotificationView(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let availableLabelWidth = frame.width - (customizations.closeButtonHidden ? 0 : customizations.closeButtonWidth)
        let availableTitleWidth = availableLabelWidth - customizations.titleXInset - customizations.titleRightInset
        let availableSubtitleWidth = availableLabelWidth - customizations.subtitleXInset - customizations.subtitleRightInset
        var bottom = CGFloat(0)
        
        if title != nil {
            titleLabel.numberOfLines = customizations.numberOfLinesInTitle
            titleLabel.frame.size.width = availableTitleWidth
            titleLabel.sizeToFit()
            titleLabel.frame = CGRect(x: customizations.titleXInset, y: customizations.titleYInset, width: availableTitleWidth, height: titleLabel.frame.height)
            
            bottom = CGRectGetMaxY(titleLabel.frame) + customizations.titleBottomInset
        }
        
        if subtitle != nil {
            var y = customizations.subtitleYInset
            if title != nil {
                y = CGRectGetMaxY(titleLabel.frame) + customizations.titleAndSubtitleSpacing
            }
            subtitleLabel.numberOfLines = customizations.numberOfLinesInSubtitle
            subtitleLabel.frame.size.width = availableSubtitleWidth
            subtitleLabel.sizeToFit()
            subtitleLabel.frame = CGRect(x: customizations.subtitleXInset, y: y, width: availableSubtitleWidth, height: subtitleLabel.frame.height)
            bottom = CGRectGetMaxY(subtitleLabel.frame) + customizations.subtitleBottomInset
        }
        
        if !customizations.closeButtonHidden {
            closeButton.frame = CGRect(x: frame.width - customizations.closeButtonWidth, y: 0, width: customizations.closeButtonWidth, height: bottom)
        }
        
        frame = CGRect(x: 0, y: 0, width: frame.width, height: bottom)
        backgroundView.frame = CGRect(x: 0, y: 0, width: frame.width, height: bottom)
        separator.frame = CGRect(x: 0, y: backgroundView.frame.height - (customizations.separatorThickness), width: backgroundView.frame.width, height: customizations.separatorThickness)
    }
}

public class IZNotificationViewController: UIViewController {
    // Resize the notification when rotating.
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        for subview in view.subviews {
            if subview is IZNotificationView {
                subview.frame.size.width = size.width
            }
        }
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIApplication.sharedApplication().statusBarStyle
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return UIApplication.sharedApplication().statusBarHidden
    }
}

public class IZNotificationWindow: UIWindow {
    // Purpose of overriding is to allow tapping through this UIWindow.
    // We don't want to prevent the user from using the app while the notification is
    // visible.
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitTestResult = super.hitTest(point, withEvent: event)
        if var view: UIView! = hitTestResult {
            while view != nil {
                if view is IZNotificationView {
                    return hitTestResult
                }
                view = view!.superview
            }
        }
        
        return nil
    }
}

public class IZNotification: NSObject {
    public var notificationQueue = [IZNotificationView]()
    public lazy var window: UIWindow! = {
        let window = IZNotificationWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = IZNotificationViewController()
        window.windowLevel = UIWindowLevelStatusBar
        return window
    }()
    public var durationTimer: NSTimer?
    public let animationDuration = NSTimeInterval(0.3)
    public var defaultCustomizations = IZNotificationCustomizations()
    public static let singleton = IZNotification()
    public var previousKeyWindow: UIWindow?
    
    public override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appStateChanged", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    public class func show(title: String?, subtitle: String?, var duration: NSTimeInterval? = nil, var customizations: IZNotificationCustomizations? = nil, onTap: (() -> Void)? = nil) {
        if customizations == nil {
            customizations = singleton.defaultCustomizations
        }
        if duration == nil {
            duration = singleton.defaultCustomizations.defaultDuration
        }
        
        let view = IZNotificationView(title: title, subtitle: subtitle, duration: duration!, customizations: customizations!, onTap: onTap)
        singleton.notificationQueue.append(view)
        if singleton.notificationQueue.count == 1 {
            singleton.presentNextNotification()
        }
    }
    
    public func appStateChanged() {
        print("BACKGROUND")
        
        
    }
    
    public class func hideCurrentNotification() {
        if let first = singleton.notificationQueue.first {
            singleton.animateOutNotificationView(first)
        }
    }
    
    public func clearNotificationQueue() {
        notificationQueue.removeAll(keepCapacity: true)
    }
    
    public func presentNextNotification() {
        if self.notificationQueue.isEmpty {
            if let keyWindow = previousKeyWindow {
                keyWindow.makeKeyAndVisible()
            }
        } else {
            let keyWindow = UIApplication.sharedApplication().keyWindow
            if keyWindow !== window {
                previousKeyWindow = keyWindow
                self.window.makeKeyAndVisible()
            } else {
                previousKeyWindow = nil
            }
            let notification = self.notificationQueue.first!
            
            self.window.rootViewController!.view.addSubview(notification)
            self.animateInNotification(notification)
        }
    }
    
    public func animateInNotification(notification: IZNotificationView) {
        notification.animating = true
        notification.frame.size.width = window.rootViewController!.view.frame.width
        notification.layoutIfNeeded()
        notification.frame.origin.y = -notification.frame.height
        UIView.animateWithDuration(animationDuration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            notification.frame.origin.y = 0
            }) { (finished) -> Void in
                notification.animating = false
                self.durationTimer?.invalidate()
                self.durationTimer = NSTimer.scheduledTimerWithTimeInterval(notification.duration, target: self, selector: "animateOutNotification:", userInfo: notification, repeats: false)
        }
    }
    
    public func animateOutNotification(timer: NSTimer) {
        animateOutNotificationView(timer.userInfo as! IZNotificationView)
    }
    
    public func animateOutNotificationView(view: IZNotificationView) {
        self.durationTimer?.invalidate()
        view.animating = true
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            view.frame.origin.y = -view.frame.height
            view.alpha = 0
            }) { success in
                view.animating = false
                self.notificationQueue.removeFirst()
                view.removeFromSuperview()
                self.presentNextNotification()
        }
    }
}