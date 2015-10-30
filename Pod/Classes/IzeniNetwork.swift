//
//  IzeniNetwork.swift
//  Izeni
//
//  Created by Christopher Bryan Henderson on 10/17/15.
//  Copyright © 2015 Izeni. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// Subclass to change host, headers, etc.
// TODO: Add multipart upload
public class IzeniNetwork {
    public struct Broadcasts {
        public static let gotHTTP401 = NSUUID()
    }
    
    public class func getApiHost() -> String {
        return Preferences.get(.apiHost)!
    }
    
    // Subclass and override to change
    public static func getJSONHeaders() -> [String:String] {
        var headers = [String:String]()
        headers["Content-Type"] = "application/json"
        if let token: String = Preferences.get(.loginToken) {
            headers["Authorization"] = "Token " + token
        }
        return headers
    }
    
    private static var manager: Manager?

    public class func createManager() -> Manager {
        return Manager.sharedInstance
    }
    
    private class func getManager() -> Manager {
        if manager == nil {
            manager = createManager()
        }
        return manager!
    }
    
    public typealias Method = Alamofire.Method
    
    public class func makeRequest(method: Method, endpoint: String, json: JSON?, success: (json: JSON?) -> Void, failure: (status: Int?, json: JSON?) -> Void) -> NSURLSessionTask {
        print(method.rawValue + " " + endpoint)
        
        let requestManager = getManager()
        let request = requestManager.request(method, getApiHost() + endpoint, parameters: json?.dictionaryObject, encoding: .JSON, headers: getJSONHeaders())
        request.responseJSON { response in
            var jsonResponse: JSON?
            print("\(response.response?.statusCode ?? 0) \(endpoint)")
            if let value = response.result.value where value is [AnyObject] || value is [String:AnyObject] {
                print(jsonResponse)
                jsonResponse = JSON(value)
            } else if let error = response.result.error {
                print(error)
            } else {
            }
            
            switch response.response?.statusCode {
            case .Some(let status) where (200..<300).contains(status):
                success(json: jsonResponse)
            case let status where status == 401:
                Broadcast.emit(Broadcasts.gotHTTP401)
                fallthrough
            default:
                failure(status: response.response?.statusCode, json: jsonResponse)
            }
        }
        return request.task
    }
    
}