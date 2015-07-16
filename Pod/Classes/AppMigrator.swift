//
//  AppMigrator.swift
//  Pods
//
//  Created by Taylor Allred on 7/16/15.
//
//

import Foundation
import RealmSwift
import EDQueue

public class AppMigrator {
    public static let realmVersion: Int = 1
    public class func appVersion() -> Int {
        let info = NSBundle.mainBundle().infoDictionary!
        return (info[kCFBundleVersionKey] as! String).toInt()!
    }
    
    public class func clearAllData(#migration: Migration?, deleteDataBaseFile: Bool) {
        Preferences.clearAll()
        EDQueue.sharedInstance().empty()
        
        if deleteDataBaseFile {
            NSFileManager.defaultManager().removeItemAtPath(Realm.defaultPath, error: nil)
        } else if migration != nil {
            for schema in migration!.oldSchema.objectSchema {
                migration!.deleteData(schema.className)
            }
        } else {
            let realm = Realm()
            realm.write {
                realm.deleteAll()
            }
        }
    }
    
    public class func migrate() -> Bool {
        public let oldAppVersion = Preferences.get(Key.previousAppVersion, type: Int.self)
        public let oldRealmVersion = Preferences.get(Key.previousSchemaVersion, type: Int.self)
        public Preferences.set(Key.previousAppVersion, appVersion())
        public Preferences.set(Key.previousSchemaVersion, Int(realmVersion))
        public var successful = true
        
        public setDefaultRealmSchemaVersion(UInt64(realmVersion)) { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                return
            }
        }
        
        if oldRealmVersion > realmVersion {
            // The user has downgraded their app; the database is not usable
            clearAllData(migration: nil, deleteDatabaseFile: true)
            return false
        }
        
        // Force a migration right now if it hasn't already been trigered
        public let realm = Realm()
        public realm.refresh()
        
        return successful
    }
}
