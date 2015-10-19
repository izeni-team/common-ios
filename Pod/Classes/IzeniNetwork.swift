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


    
    public typealias Method = Alamofire.Method
    
    public class func makeRequest(method: Method, endpoint: String, json: JSON?, manager: Alamofire.Manager? = nil, success: (json: JSON?) -> Void, failure: (status: Int?, json: JSON?) -> Void) -> NSURLSessionTask {
        var requestManager:Alamofire.Manager
        if manager != nil {
            requestManager = manager!
        } else {
            requestManager = Alamofire.Manager.sharedInstance
        }
        let request = requestManager.request(method, getApiHost() + endpoint, parameters: json?.dictionaryObject, encoding: .JSON, headers: getJSONHeaders())
        request.responseJSON { response in
            var jsonResponse: JSON?
            if let value = response.result.value where value is [AnyObject] || value is [String:AnyObject] {
                jsonResponse = JSON(value)
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