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
    public static var realmVersion: Int = 1
    public static var migrationHandler = { (migration: RLMMigration!, oldSchemaVersion: UInt64) -> Void in }
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
        let oldAppVersion = Preferences.get(Key.previousAppVersion, type: Int.self)
        let oldRealmVersion = Preferences.get(Key.previousSchemaVersion, type: Int.self)
        Preferences.set(Key.previousAppVersion, appVersion())
        Preferences.set(Key.previousSchemaVersion, Int(realmVersion))
        
        setDefaultRealmSchemaVersion(UInt64(realmVersion)) { migration, oldSchemaVersion in
            migrationHandler(migration, oldSchemaVersion)
        }
        
        if oldRealmVersion > realmVersion {
            // The user has downgraded their app; the database is not usable
            clearAllData(migration: nil, deleteDataBaseFile: true)
            return false
        }
        
        // Force a migration right now if it hasn't already been trigered
        Realm().refresh()
        
        return true
    }
}
