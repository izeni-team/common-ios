//
//  PaginatedTableViewController.swift
//  IzeniCommon
//
//  Created by Christopher Bryan Henderson on 6/3/15.
//  Copyright (c) 2015 Christopher Bryan Henderson. All rights reserved.
//

import UIKit

public protocol PaginatedTableViewDelegate: class {
    public func downloadPage(page: Int, success: (serializedResponse: AnyObject) -> Void, failure: () -> Void) -> NSURLSessionDataTask
    public func appendPageData(serializedResponse: AnyObject)
    public func isLastPage(serializedResponse: AnyObject) -> Bool
    public func clearData()
}

public class PaginatedTableViewController: UITableViewController {
    // Configurable
    public var errorTitle = "Network Error"
    public var errorMessage = "Failed to download items."
    public var delegate: PaginatedTableViewDelegate! {
        didSet {
            // The delegate should be set in the top-level class's viewDidLoad
            // If we do this here, then we avoid having silly ordering requirements
            // on the user of this class.
            assert(oldValue == nil && delegate != nil, "Setting delegate more than once isn't supported")
            refreshControl!.beginRefreshing()
            pullToRefresh()
        }
    }
    
    private var page = 0
    private var endReached = false
    private var downloadTask: NSURLSessionDataTask?
    private var wasPageReset = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "pullToRefresh", forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        assert(delegate != nil, "You forgot to set the delegate in your viewDidLoad")
    }
    
    public func pullToRefresh() {
        resetPage()
        
        downloadPage {
            self.refreshControl!.endRefreshing()
        }
    }
    
    public func resetPage() {
        page = 0
        endReached = false
        downloadTask?.cancel()
        wasPageReset = true
    }
    
    private func downloadPage(cleanup: () -> Void) {
        let clearDataIfNeeded = { () -> Void in
            if self.wasPageReset {
                self.wasPageReset = false
                self.delegate.clearData()
            }
        }
        
        let moreCleanup = { () -> Void in
            assert(self.downloadTask != nil, "Cancelled network requests shouldn't execute success or failure callback")
            self.downloadTask = nil
            cleanup()
        }
        
        downloadTask?.cancel()
        downloadTask = delegate.downloadPage(page, success: { (data) -> Void in
            clearDataIfNeeded()
            
            self.delegate.appendPageData(data)
            
            if self.delegate.isLastPage(data) {
                println("Last page")
                self.page = 0
                self.endReached = true
            } else {
                self.page += 1
            }
            
            moreCleanup()
            }, failure: { () -> Void in
                clearDataIfNeeded()
                
                let alert = UIAlertController(title: self.errorTitle, message: self.errorMessage, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { _ in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
                moreCleanup()
        })
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let visible = scrollView.contentOffset.y + scrollView.h
        let floor = scrollView.contentSize.height
        
        if visible > floor - 200 && downloadTask == nil && !endReached && page > 0 && !refreshControl!.refreshing {
            downloadPage {}
        }
    }
}

// Quite often in Izeni projects, we embed a table view controller into a view controller.
// Unfortunately, this results in two classes for one page. However, if we grab the child
// table view controller and redirect the delegate methods, then we can merge the two classes
// into only one. 
//
// See the following link for additional context:
// http://stackoverflow.com/questions/12497940/uirefreshcontrol-without-uitableviewcontroller/28870899#28870899
public extension UIViewController {
    public func setupEmbeddedPaginatedTableVC(inout tableView: UITableView) {
        let paginatedTableVC = childViewControllers.first as! PaginatedTableViewController
        paginatedTableVC.delegate = (self as! PaginatedTableViewDelegate)
        tableView = paginatedTableVC.tableView
        tableView.delegate = (self as? UITableViewDelegate)
        tableView.dataSource = (self as! UITableViewDataSource)
    }
}