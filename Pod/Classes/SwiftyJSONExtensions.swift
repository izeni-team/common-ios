//
//  SwiftyJSONExtensions.swift
//  IzeniCommon
//
//  Created by Christopher Bryan Henderson on 6/3/15.
//  Copyright (c) 2015 Christopher Bryan Henderson. All rights reserved.
//

import Foundation
import SwiftyJSON

public extension JSON {
    init(_ date: NSDate) {
        let formatted = NSDateFormatter.ISO8601.toString(date, format: .YearMonthDayHourMinuteSecondSubsecond)!
        self.init(formatted)
    }
    
    init(_ date: NSDate?) {
        if date != nil {
            self.init(date!)
        } else {
            self.init(NSNull())
        }
    }
    
    public var date: NSDate? {
        return NSDateFormatter.ISO8601.fromString(string)
    }
    
    public func rawStringMinified() -> String? {
        return self.rawString(options: .allZeros)
    }
}