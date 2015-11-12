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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var c = IZNotificationCustomizations()
        c.numberOfLinesInSubtitle = 3
        IZNotification.singleton.defaultCustomizations = c
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func showTitle() {
        IZNotification.show("This is a Title", subtitle: nil, onTap: {
            print("onTap")
        })
    }
    
    @IBAction func showTitleAndSubtitle() {
        IZNotification.show("Events and Callbacks", subtitle: "Try tapping on this message. Or swipe up, ignore, or press X to cancel.", onTap: {
            print("onTap")
            IZNotification.show("onTap Activated", subtitle: "Good job! IZNotification supports orientation too. Try it now!", duration: NSTimeInterval.infinity, onTap: {
                print("onTap")
            })
        })
    }
    
    @IBAction func showSubtitle() {
        IZNotification.show(nil, subtitle: "Think of IZNotification as a popup with 2 buttons, \"cancel\" and \"onTap.\"", onTap: {
            print("onTap")
        })
    }
    
    @IBAction func showWithInfiniteDuration() {
        IZNotification.show("This is a Sticky Notification", subtitle: "By default, titles are limited to 1 line and subtitles 2. If you're viewing this on an iPhone, you'll see that the text gets cut off somewhere in the middle of this sentence. But if you're using a 6/6s Plus, it'll probably cut off somewhere in here. Unless you're viewing this in landscape, then you might have enough room. ", duration: NSTimeInterval.infinity, onTap: {
            print("onTap")
        })
    }
    
    var tapCount = 0
    
    @IBAction func showCustomizations() {
        var c = IZNotificationCustomizations()
        c.titleAndSubtitleSpacing = 20
        c.titleXInset = 0
        c.titleYInset = 0
        c.titleBottomInset = 0
        c.titleRightInset = 0
        c.subtitleXInset = 0
        c.subtitleYInset = 0
        c.separatorThickness = 4
        c.subtitleBottomInset = c.separatorThickness + 2
        c.subtitleRightInset = 0
        c.titleFont = .systemFontOfSize(14)
        c.subtitleFont = .systemFontOfSize(10)
        c.titleColor = .whiteColor()
        c.subtitleColor = .whiteColor()
        c.numberOfLinesInTitle = 2
        c.numberOfLinesInSubtitle = 0 // Or Int.max--means same thing
        c.blurStyle = .Dark
        c.closeButtonColor = .whiteColor()
        c.closeButtonFont = .systemFontOfSize(14)
        c.closeButtonWidth = 64
        c.closeButtonText = "CLOSE"
        c.hideNotificationOnTap = false
        c.hideNotificationOnSwipeUp = false
        c.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        c.separatorColor = .whiteColor()
        
        IZNotification.show("Example of How Customizable IZNotification Is - A Comprehensive Example (Everything Changed)", subtitle: "You can change the font sizes, insets, text color, and even behavior. In this example, I've changed the maximum number of lines in the title to 2 (default is 1), and the maximum number of lines in the subtitle to Int.max (default is 2). The font size is smaller and the insets are 0 to make more room for an exorbant amount text.\n\nAlso, You can also remove the X button and disabled close on tap as well as swipe to close. In this example, swipe and tap to close has been disabled.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", customizations: c, duration: NSTimeInterval.infinity, onTap: {
            print("onTap")
        })
    }
    
    @IBAction func safety() {
        var c = IZNotificationCustomizations()
        c.numberOfLinesInSubtitle = 0
        IZNotification.show("Safety", subtitle: "IZNotification will crash (assertion failure) in debug builds if there's no title or subtitle to display, but in release mode it will instead fallback to \"Notification\" as the title and \"Tap to view\" as the subtitle, if onTap was provided, otherwise the subtitle will be empty.", customizations: c, duration: 10)
    }
}
