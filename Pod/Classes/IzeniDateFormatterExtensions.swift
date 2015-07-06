//
//  IzeniDateFormatterExtension.swift
//  IzeniCommon
//
//  Created by Jacob Ovard on 2/27/15.
//  Copyright (c) 2015 Jacob Ovard. All rights reserved.
//

import Foundation

public extension NSDateFormatter {
    struct Relative {
        static func toString(date: NSDate, dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle) -> String {
            struct Static {
                static var formatter = NSDateFormatter()
            }
            Static.formatter.dateStyle = dateStyle
            Static.formatter.timeStyle = timeStyle
            Static.formatter.doesRelativeDateFormatting = true
            
            let now = NSDate()
            if dateStyle != .NoStyle && now.daysSince(date) < 7 && now.daysSince(date) > 1 {
                Static.formatter.dateStyle = .NoStyle
                
                var weekday = NSDateFormatter.getWeekday(date)
                if dateStyle == .MediumStyle {
                    return weekday + ", " + Static.formatter.stringFromDate(date)
                } else if dateStyle == .ShortStyle {
                    return weekday.left(3) + ", " + Static.formatter.stringFromDate(date)
                } else {
                    return weekday + " at " + Static.formatter.stringFromDate(date)
                }
            }
            
            return Static.formatter.stringFromDate(date)
        }
    }
    
    public class func getWeekday(date: NSDate) -> String {
        switch date.weekday {
        case .Sunday: return "Sunday"
        case .Monday: return "Monday"
        case .Tuesday: return "Tuesday"
        case .Wednesday: return "Wednesday"
        case .Thursday: return "Thursday"
        case .Friday: return "Friday"
        case .Saturday: return "Saturday"
        }
    }
    
    struct ISO8601 {
        enum Format {
            case Automatic
            case YearMonthDayHourMinuteSecondSubsecond
            case YearMonthDayHourMinuteSecond
            case YearMonthDay
        }
        
        static func fromString(string: String?) -> NSDate? {
            return fromString(string, format: .Automatic)
        }
        
        static func fromString(string: String?, format: Format) -> NSDate? {
            if string == nil {
                return nil
            }
            
            switch format {
            case .Automatic:
                for formatter in formatters.values {
                    if let date = formatter.dateFromString(string!) {
                        return date
                    }
                }
                return nil
            default:
                return formatters[format]!.dateFromString(string!)
            }
        }
        
        static func toString(date: NSDate?) -> String? {
            return toString(date, format: .Automatic)
        }
        
        static func toString(date: NSDate?, format: Format) -> String? {
            if date == nil {
                return nil
            }
            
            switch format {
            case .Automatic:
                return formatters[.YearMonthDayHourMinuteSecond]!.stringFromDate(date!)
            default:
                return formatters[format]!.stringFromDate(date!)
            }
        }
        
        static var formatters: [Format:NSDateFormatter] {
            struct Static {
                static var formatters = [Format:NSDateFormatter]()
            }
            
            if Static.formatters.isEmpty {
                let add = { (format: String, e: Format) -> Void in
                    let formatter = NSDateFormatter()
                    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    formatter.dateFormat = format
                    Static.formatters[e] = formatter
                }
                
                add("yyyy-MM-dd'T'HH:mm:ss.SSSZ", .YearMonthDayHourMinuteSecondSubsecond)
                add("yyyy-MM-dd'T'HH:mm:ssZ", .YearMonthDayHourMinuteSecond)
                add("yyyy-MM-dd", .YearMonthDay)
            }
            
            return Static.formatters
        }
    }
}