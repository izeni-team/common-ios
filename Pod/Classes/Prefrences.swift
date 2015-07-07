//
//  GenericPrefrences.swift
//  Pods
//
//  Created by Taylor Allred on 7/7/15.
//
//

import Foundation

struct Key {
    let name: String
    func path() -> String {
        return "Key." + name
    }
    
    static let previousSchemaVersion = Key(name: "previousSchemaVersion")
    static let previousAppVersion = Key(name: "previousAppVersion")
    static let loginSuccessful = Key(name: "loginSuccessful")
    static let pushToken = Key(name: "pushToken")
}

class Preferences {
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    class func clear(key: Key) {
        defaults.removeObjectForKey(key.path())
        defaults.synchronize()
    }
    
    class func set<T: AnyObject>(key: Key, _ value: T) {
        defaults.setObject(value, forKey: key.path())
        defaults.synchronize()
    }
    
    class func get<T>(key: Key, type: T.Type) -> T? {
        return defaults.objectForKey(key.path()) as? T
    }
    
    static var keep = [
        Key.pushToken,
        Key.previousAppVersion,
        Key.previousSchemaVersion
    ]
    
    class func clearAll() {
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