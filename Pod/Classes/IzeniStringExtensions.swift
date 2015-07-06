//
//  IzeniStringExtensions.swift
//  IzeniCommon
//
//  Created by Bryan Henderson on 2/25/15.
//  Copyright (c) 2015 Bryan Henderson. All rights reserved.
//

import Foundation

// All functions here match http://doc.qt.io/qt-5/qstring.html as closely as possible.
// Documentation and behavior should match pretty closely.
//
// One subtle difference is that Swift strings are immutable, whereas QString is mutable.

public extension String {
    // Returns the number of characters in the string
    public var size: Int {
        return count(self)
    }
    
    public var length: Int {
        return count(self)
    }
    
    // Returns a substring that contains the n leftmost characters of the string.
    //
    // The entire string is returned if n is greater than size() or less than zero.
    public func left(n: Int) -> String {
        if n < 0 || n >= count(self) {
            // Return entire string
            return self
        }
        
        return (self as NSString).substringToIndex(n)
    }
    
    // Returns a substring that contains the n rightmost characters of the string.
    //
    // The entire string is returned if n is greater than size() or less than zero.
    public func right(n: Int) -> String {
        if n < 0 || n >= count(self) {
            // Return entire string
            return self
        }
        
        return (self as NSString).substringFromIndex(count(self) - n)
    }
    
    // Returns a string that contains n characters of this string, starting at the specified position index.
    //
    // Returns an empty string if the position index exceeds the length of the string.  If there are less than n characters available in the string starting at the given position, or if n is -1 (default), the function returns all characters that are available from the specified position.
    public func mid(position: Int, length: Int = -1) -> String {
        assert(position >= 0)
        assert(length >= -1)
        
        if position >= count(self) {
            return "" // Position excdeeds length of string
        }
        
        let end = count(self) - position
        let safeLength = length == -1 ? end : min(length, end)
        return (self as NSString).substringWithRange(NSMakeRange(position, safeLength))
    }
    
    public func replace(before: String, with: String) -> String {
        return stringByReplacingOccurrencesOfString(before, withString: with)
    }
    
    public func replace(before: String, with: String, caseInsensitive: Bool) -> String {
        return stringByReplacingOccurrencesOfString(before, withString: with, options: caseInsensitive ? .CaseInsensitiveSearch : .allZeros)
    }
    
    public func replace(#regex: String, with: String) -> String {
        return stringByReplacingOccurrencesOfString(regex, withString: with, options: .RegularExpressionSearch)
    }
    
    public func replace(#regex: String, with: String, caseInsensitive: Bool) -> String {
        let options: NSStringCompareOptions = (caseInsensitive ? .CaseInsensitiveSearch : .allZeros) | .RegularExpressionSearch
        return stringByReplacingOccurrencesOfString(regex, withString: with, options: options)
    }
    
    public func remove(string: String) -> String {
        return stringByReplacingOccurrencesOfString(string, withString: "")
    }
    
    public func remove(string: String, caseInsensitive: Bool) -> String {
        return stringByReplacingOccurrencesOfString(string, withString: "", options: caseInsensitive ? .CaseInsensitiveSearch : .allZeros)
    }
    
    public func remove(#regex: String) -> String {
        return stringByReplacingOccurrencesOfString(regex, withString: "", options: .RegularExpressionSearch)
    }
    
    public func remove(#regex: String, caseInsensitive: Bool) -> String {
        let options: NSStringCompareOptions = (caseInsensitive ? .CaseInsensitiveSearch : .allZeros) | .RegularExpressionSearch
        return stringByReplacingOccurrencesOfString(regex, withString: "", options: options)
    }
    
    public func remove(position: Int, length: Int) -> String {
        assert(position >= 0)
        assert(length >= -1)
        
        if position >= count(self) {
            return self
        }
        
        let end = count(self) - position
        let safeLength = length == -1 ? end : min(length, end)
        let range = NSMakeRange(position, safeLength)
        return (self as NSString).stringByReplacingCharactersInRange(range, withString: "")
    }
    
    public func startsWith(string: String) -> Bool {
        return rangeOfString(string)?.startIndex == startIndex
    }
    
    public func startsWith(string: String, caseInsensitive: Bool) -> Bool {
        return rangeOfString(string, options: caseInsensitive ? .CaseInsensitiveSearch : .allZeros)?.startIndex == startIndex
    }
    
    public func startsWith(#regex: String) -> Bool {
        return rangeOfString(regex, options: .RegularExpressionSearch)?.startIndex == startIndex
    }
    
    public func startsWith(#regex: String, caseInsensitive: Bool) -> Bool {
        let options: NSStringCompareOptions = (caseInsensitive ? .CaseInsensitiveSearch : .allZeros) | .RegularExpressionSearch
        return rangeOfString(regex, options: options)?.startIndex == startIndex
    }
    
    public func endsWith(string: String) -> Bool {
        return rangeOfString(string)?.endIndex == endIndex
    }
    
    public func endsWith(string: String, caseInsensitive: Bool) -> Bool {
        return rangeOfString(string, options: caseInsensitive ? .CaseInsensitiveSearch : .allZeros)?.endIndex == endIndex
    }
    
    public func endsWith(#regex: String) -> Bool {
        return rangeOfString(regex, options: .RegularExpressionSearch)?.endIndex == endIndex
    }
    
    public func endsWith(#regex: String, caseInsensitive: Bool) -> Bool {
        let options: NSStringCompareOptions = (caseInsensitive ? .CaseInsensitiveSearch : .allZeros) | .RegularExpressionSearch
        return rangeOfString(regex, options: options)?.endIndex == endIndex
    }
    
    public func contains(string: String) -> Bool {
        return rangeOfString(string) != nil
    }
    
    public func contains(string: String, caseInsensitive: Bool) -> Bool {
        return rangeOfString(string, options: caseInsensitive ? .CaseInsensitiveSearch : .allZeros) != nil
    }
    
    public func contains(#regex: String) -> Bool {
        return rangeOfString(regex, options: .RegularExpressionSearch) != nil
    }
    
    public func contains(#regex: String, caseInsensitive: Bool) -> Bool {
        let options: NSStringCompareOptions = (caseInsensitive ? .CaseInsensitiveSearch : .allZeros) | .RegularExpressionSearch
        return rangeOfString(regex, options: options) != nil
    }
    
    // Returns -1 if not found
    public func indexOf(string: String) -> Int {
        let index = (self as NSString).rangeOfString(string).location
        if index == NSNotFound {
            return -1
        } else {
            return index
        }
    }
}