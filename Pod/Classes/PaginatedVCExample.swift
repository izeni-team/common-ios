//
//  PaginatedVCExample.swift
//  IzeniCommon
//
//  Created by Christopher Bryan Henderson on 6/3/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import UIKit

public class PaginatedVCExample: PaginatedTableViewController, PaginatedTableViewDelegate {
    override public func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    public var data: [String] = []
    
    public func downloadPage(page: Int, success: (serializedResponse: AnyObject) -> Void, failure: () -> Void) -> NSURLSessionDataTask {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        
        let url = "https://demo.toweez.com/api/ticket/?page=\(page + 1)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = [
            "Authorization": "Token 1973d2b956c77db82c94b90802f8988bf7d4fa9c"
        ]
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error?.code == NSURLErrorCancelled {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let statusCode = (response as? NSHTTPURLResponse)?.statusCode ?? 0
                print("\(statusCode) \(url)")
                if statusCode == 200 {
                    let serialized = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! [String:AnyObject]
                    success(serializedResponse: serialized)
                } else {
                    failure()
                }
            })
        })
        print("GET \(url)")
        task.resume()
        return task
    }
    
    public func isLastPage(serializedResponse: AnyObject) -> Bool {
        let json = (serializedResponse as! [String:AnyObject])
        return json["next"] as? String == nil
    }
    
    public func clearData() {
        data = []
    }
    
    public func appendPageData(serializedResponse: AnyObject) {
        let response = serializedResponse as! [String:AnyObject]
        for result in response["results"] as? [[String:AnyObject]] ?? [] {
            let id = result["id"] as! String
            assert(!data.contains(id))
            data.append(id)
        }
        tableView.reloadData()
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel!.text = data[indexPath.row]
        return cell
    }
}