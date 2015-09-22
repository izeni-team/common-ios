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
    
    public var path: String {
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
        defaults.removeObjectForKey(key.path)
        defaults.synchronize()
    }
    
    public class func isSet(key: Key) -> Bool {
        return defaults.objectForKey(key.path) != nil
    }
    
    public class func set(key: Key, _ boolean: Bool?) {
        _set(key, boolean != nil ? NSNumber(bool: boolean!) : nil)
    }
    
    public class func get(key: Key) -> Bool {
        return _get(key, NSNumber.self)?.boolValue ?? false
    }
    
    public class func get(key: Key, defaultsTo: Bool) -> Bool {
        return _get(key, NSNumber.self)?.boolValue ?? defaultsTo
    }
    
    public class func set(key: Key, _ integer: Int?) {
        _set(key, integer != nil ? NSNumber(integer: integer!) : nil)
    }
    
    public class func get(key: Key) -> Int {
        return _get(key, NSNumber.self)?.integerValue ?? 0
    }
    
    public class func set(key: Key, _ string: String?) {
        _set(key, string)
    }
    
    public class func get(key: Key) -> String? {
        return _get(key, NSString.self) as? String
    }
    
    public class func set(key: Key, _ data: NSData?) {
        _set(key, data)
    }
    
    public class func get(key: Key) -> NSData? {
        return _get(key, NSData.self)
    }
    
    private class func _set(key: Key, _ object: NSObject?) {
        if let object = object {
            defaults.setObject(object, forKey: key.path)
        } else {
            defaults.removeObjectForKey(key.path)
        }
        defaults.synchronize()
    }
    
    private class func _get<T: NSObject>(key: Key, _ type: T.Type) -> T? {
        return defaults.objectForKey(key.path) as? T
    }
    
    public static var keep = [
        Key.pushToken,
        Key.previousAppVersion,
        Key.previousSchemaVersion,
        Key.hasShownOnboard
    ]
    
    public class func clearAll() {
        let dictionary = defaults.dictionaryRepresentation()
        let keep = self.keep.map { $0.path }
        for key in dictionary.keys {
            if !keep.contains(key) {
                defaults.removeObjectForKey(key)
            }
        }
        defaults.synchronize()
    }
}