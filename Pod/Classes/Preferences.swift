//
//  GenericPrefrences.swift
//  Pods
//
//  Created by Taylor Allred on 7/7/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import Foundation

public struct Key {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public func path() -> String {
        return "Key." + name
    }
    
    public static let previousSchemaVersion = Key(name: "previousSchemaVersion")
    public static let previousAppVersion = Key(name: "previousAppVersion")
    public static let loginSuccessful = Key(name: "loginSuccessful")
    public static let pushToken = Key(name: "pushToken")
    public static let hasShownOnboard = Key(name: "hasShownOnboard")
}

public class Preferences {
    public static let defaults = NSUserDefaults.standardUserDefaults()
    
    public class func clear(key: Key) {
        defaults.removeObjectForKey(key.path())
        defaults.synchronize()
    }
    
    public class func set<T: NSObject>(key: Key, _ value: T) {
        defaults.setObject(value, forKey: key.path())
        defaults.synchronize()
    }
    
    public class func get(key: Key, type: Bool.Type) -> Bool {
        return defaults.boolForKey(key.path())
    }
    
    public class func get<T>(key: Key, type: T.Type) -> T? {
        return defaults.objectForKey(key.path()) as? T
    }
    
    public static var keep = [
        Key.pushToken,
        Key.previousAppVersion,
        Key.previousSchemaVersion,
        Key.hasShownOnboard
    ]
    
    public class func clearAll() {
        let dictionary = defaults.dictionaryRepresentation()
        let keep = self.keep.map { $0.path() }
        for key in dictionary.keys {
            if !contains(keep, key as! String) {
                defaults.removeObjectForKey(key as! String)
            }
        }
        defaults.synchronize()
    }
}