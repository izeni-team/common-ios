//
//  Migrator.swift
//  Pods
//
//  Created by Taylor Allred on 7/16/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import Foundation
import RealmSwift
import EDQueue

public class Migrator {
    public static var succeeded = false
    public static var realmVersion: UInt64 = 0
    public class func appVersion() -> Int {
        let info = NSBundle.mainBundle().infoDictionary!
        return (info[kCFBundleVersionKey] as! String).toInt()!
    }
    
    public class func clearAllData(#migration: Migration?, deleteDataBaseFile: Bool) {
        Preferences.clearAll()
        EDQueueActuator.singleton.clearQueues()
        
        if deleteDataBaseFile {
            NSFileManager.defaultManager().removeItemAtPath(Realm.defaultPath, error: nil)
        } else if let migration = migration {
            for schema in migration.oldSchema.objectSchema {
                migration.deleteData(schema.className)
            }
        } else {
            let realm = Realm()
            realm.write {
                realm.deleteAll()
            }
        }
    }
    
    public class func migrate(migrationHandler: (migration: Migration!, oldSchemaVersion: UInt64) -> Void) -> Bool {
        succeeded = _migrate(migrationHandler)
        return succeeded
    }
    
    private class func _migrate(migrationHandler: (migration: Migration!, oldSchemaVersion: UInt64) -> Void) -> Bool {
        let oldAppVersion = Preferences.get(Key.previousAppVersion, type: Int.self)
        let oldRealmVersion = Preferences.get(Key.previousSchemaVersion, type: UInt64.self) ?? 0
        Preferences.set(Key.previousAppVersion, appVersion())
        Preferences.set(Key.previousSchemaVersion, Int(realmVersion))
        
        setDefaultRealmSchemaVersion(realmVersion, migrationHandler)
        
        if oldRealmVersion > realmVersion {
            // The user has downgraded their app; the database is not usable
            clearAllData(migration: nil, deleteDataBaseFile: true)
            return false
        }
        
        // Force a migration right now if it hasn't already been triggered
        Realm().refresh()
        
        return true
    }
}
