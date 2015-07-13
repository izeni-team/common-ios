//
//  GenericPrefrences.swift
//  Pods
//
//  Created by Taylor Allred on 7/7/15.
//
//

import Foundation

public struct Key {
    let name: String
    func path() -> String {
        return "Key." + name
    }
    
    public static let previousSchemaVersion = Key(name: "previousSchemaVersion")
    public static let previousAppVersion = Key(name: "previousAppVersion")
    public static let loginSuccessful = Key(name: "loginSuccessful")
    public static let pushToken = Key(name: "pushToken")
}

public class Preferences {
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    public class func clear(key: Key) {
        defaults.removeObjectForKey(key.path())
        defaults.synchronize()
    }
    
    public class func set<T: AnyObject>(key: Key, _ value: T) {
        defaults.setObject(value, forKey: key.path())
        defaults.synchronize()
    }
    
    public class func get<T>(key: Key, type: T.Type) -> T? {
        return defaults.objectForKey(key.path()) as? T
    }
    
    public static var keep = [
        Key.pushToken,
        Key.previousAppVersion,
        Key.previousSchemaVersion
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