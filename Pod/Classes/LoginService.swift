//
//  LoginService.swift
//  Pods
//
//  Created by Taylor Allred on 7/16/15.
//
//

import Foundation

public class LoginService {
    public struct Broadcasts {
        public static let loggedOut = NSUUID()
    }
    
    public class func logout() {
        Preferences.clearAll()
        Broadcast.emit(Broadcasts.loggedOut)
    }
    
    public class func login() {
//        public static var downloadStep = {}
    }
}