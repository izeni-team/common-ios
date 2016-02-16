# Izeni's Common iOS Code http://www.izeni.com/

[![CI Status](http://img.shields.io/travis/bhenderson@izeni.com/ios-pod-test.svg?style=flat)](https://travis-ci.org/bhenderson@izeni.com/ios-pod-test)
[![Version](https://img.shields.io/cocoapods/v/ios-pod-test.svg?style=flat)](http://cocoapods.org/pods/ios-pod-test)
[![License](https://img.shields.io/cocoapods/l/ios-pod-test.svg?style=flat)](http://cocoapods.org/pods/ios-pod-test)
[![Platform](https://img.shields.io/cocoapods/p/ios-pod-test.svg?style=flat)](http://cocoapods.org/pods/ios-pod-test)

## Usage

This project contains several miscellaneous utilities.
The example project isn't being maintained as of August 2015. Please take a peek at the individual source files or read below to learn more.

#### IzeniBroadcast
- Easier to use than NSNotificationCenter
- Objective-C and Swift support
- Automatic removal of listeners upon dealloc; no need to call removeObserver(self)
- Events are identified by UUIDs, which are less likely to collide than user-defined keys
- Events are delivered on the main thread, making GUI updates worry-free
- Events are delivered asynchronously to guarantee correctness, but there is a synchronous option available for those corner cases

```swift
class LoginService {
    static let userDidLogout = NSUUID() // This is the broadcast ID
    static var userID: String?
    
    class func logout() {
        ...
        
        // Will call method on LocationTracker and any other monitoring instances.
        Broadcast.emit(userDidLogout, value: userID) // Async, main thread delivery
    }
}
...
class LocationTracker: NSObject {
    static let singleton = LocationTracker()
    static func start() {
        singleton // static let vars are lazy instantiated; this initializes the singleton
    }
    
    init() {
        ...
        // The selector must be an instance method, as class/static functions aren't supported.
        monitorBroadcast(LoginService.userDidLogout, selector: "stop")
    }
    
    func stop() {
        ...
    }
```

## Requirements



## Installation

ios-pod-test is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Izeni', :git => 'https://dev.izeni.net/tallred/IOS-Common-Private-Pod.git'
```

If you wish to co-develop this pod with your project, add this line to your Podfile instead of the one above:

```ruby
pod 'Izeni', :path => '~/path/to/this/project'
```

Be sure that your Podfile has the following line too:

```ruby
use_frameworks!
```

## Credits

Bryan Henderson, Thane Brimhall, Jacob Ovard, Taylor Allred, Skyler Smith, Matthew Bailey

## License

Izeni's Common iOS Code is available under the MIT license. See the LICENSE file for more info.