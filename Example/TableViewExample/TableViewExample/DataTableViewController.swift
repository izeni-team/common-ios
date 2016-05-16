//
//  DataTableViewController.swift
//  TableViewExample
//
//  Created by David Ulbrich on 5/16/16.
//  Copyright © 2016 David Ulbrich. All rights reserved.
//

import Foundation
import UIKit

class DataTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        cell.textLabel?.text = "Section: \(indexPath.section) Row: \(indexPath.row)"
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
}