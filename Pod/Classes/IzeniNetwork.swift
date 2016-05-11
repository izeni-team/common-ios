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

public struct JSONRequestFailureResponse {
    public let status: Int?
    public let result: JSON?
    public let message: String
    
    public func showAlert(vc: UIViewController, title: String = "Error") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(.okAction())
        vc.presentViewController(alert, animated: true, completion: nil)
    }
}

public enum JSONRequestResponse {
    case Success(result: JSON)
    case Failure(result: JSONRequestFailureResponse)
}

// TODO: Add multipart upload
public class IzeniNetwork {
    public struct Broadcasts {
        public static let gotHTTP401 = NSUUID()
    }
    
    // Subclass and override to change
    public class func getJSONHeaders() -> [String:String] {
        var headers = [String:String]()
        headers["Content-Type"] = "application/json"
        if let token: String = Preferences.get(.loginToken) {
            headers["Authorization"] = "Token " + token
        }
        return headers
    }
    
    public class var disableSSL: Bool {
        return false
    }
    public class var getAPIHost: String {
        return "https://www.google.com/"
    }
    
    public static let manager: Manager = {
        if IzeniNetwork.disableSSL {
            let url = NSURL(string: IzeniNetwork.getAPIHost)!
            let policies = [
                url.host!: ServerTrustPolicy.DisableEvaluation
            ]
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            config.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
            return Manager(configuration: config, serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
        } else {
            return Manager.sharedInstance
        }
    }()
    
    public typealias Method = Alamofire.Method
    
    public class func makeRequest(method: Method, endpoint: String, json: JSON?, completion: (result: JSONRequestResponse) -> Void) -> NSURLSessionTask {
        print("<--- \(method.rawValue) \(endpoint)")
        
        let request = manager.request(method, getAPIHost + endpoint, parameters: json?.dictionaryObject, encoding: .JSON, headers: getJSONHeaders())
        request.responseJSON { response in
            if response.result.error?.code == NSURLErrorCancelled {
                return
            }
            let failedConnection = "Failed to connect to the server. Please check you Internet Connection and try again."
            let unknown = "An unknown error occcured."
            let serverError = "The server appears to be experiencing a temporary glitch. If the problem persists, please contact support."
            
            guard let status = response.response?.statusCode else {
                completion(result: .Failure(result: JSONRequestFailureResponse(status: nil, result: nil, message: failedConnection)))
                return
            }
            
            print("---> \(status) \(endpoint)")
            var jsonResponse: JSON?
            
            if let value = response.result.value where value is [AnyObject] || value is [String:AnyObject] {
                print(jsonResponse)
                jsonResponse = JSON(value)
            } else if let error = response.result.error {
                print(error)
            }
            
            let error = { (message: String) -> Void in
                completion(result: .Failure(result: JSONRequestFailureResponse(status: status, result: jsonResponse, message: message)))
            }
            
            switch status {
            case 200..<300:
                completion(result: .Success(result: jsonResponse ?? JSON(NSNull())))
            case 401:
                completion(result: .Failure(result: JSONRequestFailureResponse(status: status, result: jsonResponse, message: "Unauthorized.")))
            case 400...499:
                if let field = jsonResponse?.dictionaryValue.keys.first, message = jsonResponse?[field].arrayValue.first?.string {
                    error(field + ": " + message)
                } else if let responseDictionary = response.result.value as? [String: AnyObject], message = responseDictionary["detail"] as? String {
                    error(message)
                } else if let message = jsonResponse?.arrayValue.first?.string {
                    error(message)
                } else {
                    error(unknown)
                }
            case 500...599:
                error(serverError)
            default:
                error(unknown)
            }
        }
        return request.task
    }
}