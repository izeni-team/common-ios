//
//  IzeniDateExtensions.swift
//  IzeniCommon
//
//  Created by Bryan Henderson on 2/22/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import Foundation

public enum Weekday: Int {
    case Sunday = 0
    case Monday = 1
    case Tuesday = 2
    case Wednesday = 3
    case Thursday = 4
    case Friday = 5
    case Saturday = 6
    
    static public let all: [Weekday] = [.Sunday, .Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday]
}

public extension NSDate {
    private class var calendar: NSCalendar {
        struct Static {
            static let calendar = NSCalendar.currentCalendar()
        }
        return Static.calendar
    }
    
    private func component(unit: NSCalendarUnit) -> Int {
        return NSDate.calendar.component(unit, fromDate: self)
    }
    
    public func day() -> Int {
        return component(.Day)
    }
    
    public func month() -> Int {
        return component(.Month)
    }
    
    public func weekOfMonth() -> Int {
        return component(.WeekOfMonth)
    }
    
    public func weekOfMonth(startOfWeek startOfWeek: Weekday) -> Int {
        let weekdayOfFirst = self.beginningOfMonth().weekday
        let converted = NSDate.convertWeekday(weekdayOfFirst, toStartOfWeek: startOfWeek)
        let day = self.day() + converted
        return Int(ceil(Double(day) / 7))
    }
    
    public func year() -> Int {
        return component(.Year)
    }
    
    // NOTE: NSCalendar is 1 indexed, but this Weekday enum is ZERO INDEXED!
    public var weekday: Weekday {
        return Weekday(rawValue: component(.Weekday) - 1)!
    }
    
    public convenience init(weekday: Weekday, withStartOfWeek: Weekday) {
        let today = NSDate().strippedTime()
        let desiredDayInWeek = NSDate.convertWeekday(weekday, toStartOfWeek: withStartOfWeek)
        let currentDayInWeek = NSDate.convertWeekday(today.weekday, toStartOfWeek: withStartOfWeek)
        let daysToAdd = desiredDayInWeek - currentDayInWeek
        let date = today.addDays(daysToAdd)
        self.init(timeInterval: 0, sinceDate: date)
    }
    
    public func beginningOfDay() -> NSDate {
        return self.strippedTime()
    }
    
    public func beginningOfMonth() -> NSDate {
        let days = -day() + 1
        return self.addDays(days).beginningOfDay()
    }
    
    public func beginningOfYear() -> NSDate {
        return self.beginningOfMonth().addMonths(-self.month() + 1)
    }
    
    public func daysSince(date: NSDate) -> Int {
        let fromDate = date.strippedTime()
        let toDate = self.strippedTime()
        let difference = NSDate.calendar.components(.Day, fromDate:fromDate, toDate: toDate, options: [])
        return difference.day
    }
    
    public func yearsSince(date: NSDate) -> Int {
        let fromDate = date.strippedTime()
        let toDate = self.strippedTime()
        let difference = NSDate.calendar.components(.Year, fromDate: fromDate, toDate: toDate, options: [])
        return difference.year
    }
    
    public func addWeeks(weeks: Int) -> NSDate {
        return NSDate.calendar.dateByAddingUnit(.WeekOfYear, value: weeks, toDate: self, options: [])!
    }
    
    public func addDays(days: Int) -> NSDate {
        let components = NSDateComponents()
        components.day = days
        return NSDate.calendar.dateByAddingComponents(components, toDate: self, options: [])!
    }
    
    public func addMonths(months: Int) -> NSDate {
        let components = NSDateComponents()
        components.month = months
        return NSDate.calendar.dateByAddingComponents(components, toDate: self, options: [])!
    }
    
    public class func convertWeekday(weekday: Weekday, toStartOfWeek: Weekday) -> Int {
        let converted = weekday.rawValue - toStartOfWeek.rawValue
        if converted < 0 {
            return converted + 7
        } else {
            return converted
        }
    }
    
    public class func daysSinceWeekday(weekday: Weekday, withStartOfWeek: Weekday) -> Int {
        let weekdayNumber = convertWeekday(weekday, toStartOfWeek: withStartOfWeek)
        if weekdayNumber == 0 {
            return 0
        } else {
            return 7 - weekdayNumber
        }
    }
    
    public func isYesterday() -> Bool {
        return self.daysSince(NSDate()) == -1
    }
    
    public func isToday() -> Bool {
        return self.daysSince(NSDate()) == 0
    }
    
    public func isTomorrow() -> Bool {
        return self.daysSince(NSDate()) == 1
    }
    
    public func isThisWeek(startOfWeek startOfWeek: Weekday) -> Bool {
        let start = NSDate(weekday: startOfWeek, withStartOfWeek: startOfWeek)
        let end = start.addWeeks(1)
        return self >= start && self < end
    }
    
    public func isThisMonth() -> Bool {
        let start = NSDate().beginningOfMonth()
        let end = NSDate().addMonths(1).beginningOfMonth()
        return self >= start && self < end
    }
    
    public func strippedTime() -> NSDate {
        var stripped: NSDate?
        NSDate.calendar.rangeOfUnit(.Day, startDate:&stripped, interval: nil, forDate: self)
        return stripped!
    }
}

public func ==(left: NSDate, right: NSDate) -> Bool {
    return left.timeIntervalSinceDate(right) == 0
}

public func >=(left: NSDate, right: NSDate) -> Bool {
    return left.timeIntervalSinceDate(right) >= 0
}

public func <=(left: NSDate, right: NSDate) -> Bool {
    return left.timeIntervalSinceDate(right) <= 0
}

public func >(left: NSDate, right: NSDate) -> Bool {
    return left.timeIntervalSinceDate(right) > 0
}

public func <(left: NSDate, right: NSDate) -> Bool {
    return left.timeIntervalSinceDate(right) < 0
}