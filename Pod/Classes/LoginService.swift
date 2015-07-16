//
//  LoginService.swift
//  Pods
//
//  Created by Taylor Allred on 7/16/15.
//
//

import Foundation

public class LoginService {
    struct Broadcasts {
        static let loggedOut = NSUUID()
    }
    
    class func logout() {
        Preferences.clearAll()
        Broadcast.emit(Broadcasts.loggedOut)
    }
}