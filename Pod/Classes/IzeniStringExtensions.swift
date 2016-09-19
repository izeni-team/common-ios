//
//  IzeniStringExtensions.swift
//  IzeniCommon
//
//  Created by Bryan Henderson on 2/25/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import Foundation

// All functions here match http://doc.qt.io/qt-5/qstring.html as closely as possible.
// Documentation and behavior should match pretty closely.
//
// One subtle difference is that Swift strings are immutable, whereas QString is mutable.

public extension String {
    /// - returns: The number of characters in the string
    public var size: Int {
        return self.characters.count
    }
    /// - returns: The number of characters in the string
    public var length: Int {
        return self.characters.count
    }
    /// - returns: A substring that contains the n leftmost characters of the string. The entire string is returned if n is greater than size() or less than zero.
    public func left(n: Int) -> String {
        if n < 0 || n >= self.characters.count {
            // Return entire string
            return self
        }
        
        return (self as NSString).substring(to: n)
    }
    /// - returns: A substring that contains the n rightmost characters of the string. The entire string is returned if n is greater than size() or less than zero.
    public func right(n: Int) -> String {
        if n < 0 || n >= self.characters.count {
            // Return entire string
            return self
        }
        
        return (self as NSString).substring(from: self.characters.count - n)
    }
    /// - returns: A string that contains n characters of this string, starting at the specified position index. Returns an empty string if the position index exceeds the length of the string.  If there are less than n characters available in the string starting at the given position, or if n is -1 (default), the function returns all characters that are available from the specified position.
    public func mid(position: Int, length: Int = -1) -> String {
        assert(position >= 0)
        assert(length >= -1)
        
        if position >= self.characters.count {
            return "" // Position excdeeds length of string
        }
        
        let end = self.characters.count - position
        let safeLength = length == -1 ? end : min(length, end)
        return (self as NSString).substring(with: NSMakeRange(position, safeLength))
    }
    /// - returns: A string where every occurrence of 'before' is replaced with 'with.'
    public func replace(before: String, with: String) -> String {
        return replacingOccurrences(of: before, with: with)
    }
    /// - returns: A string where every occurrence of 'before' (using the given case sensitivity) is replaced with 'with.'
    public func replace(before: String, with: String, caseInsensitive: Bool) -> String {
        return replacingOccurrences(of: before, with: with, options: caseInsensitive ? .caseInsensitive : [])
    }
    /// :retuns: A string where every occurrence of the regular express 'regex' is replaced with 'with'
    public func replace(regex: String, with: String) -> String {
        return replacingOccurrences(of: regex, with: with, options: .regularExpression)
    }
    /// :retuns: A string where every occurrence of the regular express 'regex' (using the given case sensitivity) is replaced with 'with'
    public func replace(regex: String, with: String, caseInsensitive: Bool) -> String {
        let options = NSString.CompareOptions.regularExpression.union(caseInsensitive ? .caseInsensitive : [])
        return replacingOccurrences(of: regex, with: with, options: options)
    }
    /// - returns: A string where every occurrence of 'string' is removed.
    public func remove(string: String) -> String {
        return replacingOccurrences(of: string, with: "")
    }
    /// - returns: A string where every occurrence of 'string' (using the given case sensitivity) is removed.
    public func remove(string: String, caseInsensitive: Bool) -> String {
        return replacingOccurrences(of: string, with: "", options: caseInsensitive ? .caseInsensitive : [])
    }
    /// - returns: A string where every occurrence of the regular expression 'regex' is removed.
    public func remove(regex: String) -> String {
        return replacingOccurrences(of: regex, with: "", options: .regularExpression)
    }
    /// - returns: A string where every occurrence of the regular expression 'regex' (using the given case sensitivity) is removed.
    public func remove(regex: String, caseInsensitive: Bool) -> String {
        let options = NSString.CompareOptions.regularExpression.union(caseInsensitive ? .caseInsensitive : [])
        return replacingOccurrences(of: regex, with: "", options: options)
    }
    /**
    - parameter position: The index of the first character to be removed. Must be non-negative
    - parameter length: The number of characters to be removed including and after the one at 'position'. '-1' removes all the characters after and including the one at 'position.'
    - returns: A string where 'length' characters are removed, starting at and including the one at index 'position.'
    */
    public func remove(position: Int, length: Int) -> String {
        assert(position >= 0)
        assert(length >= -1)
        
        if position >= self.characters.count {
            return self
        }
        
        let end = self.characters.count - position
        let safeLength = length == -1 ? end : min(length, end)
        let range = NSMakeRange(position, safeLength)
        return (self as NSString).replacingCharacters(in: range, with: "")
    }
    /// - returns: True if the string starts with the given string, False otherwise
    public func startsWith(string: String) -> Bool {
        return hasPrefix(string)
    }
    /// - returns: True if the string starts with the given string (using the given case sensitivity), False otherwise.
    public func startsWith(string: String, caseInsensitive: Bool) -> Bool {
        return range(of: string, options: caseInsensitive ? .caseInsensitive : [])?.lowerBound == startIndex
    }
    /// - returns: True if the string ends with the given string, False otherwise
    public func endsWith(string: String) -> Bool {
        return hasSuffix(string)
    }
    /// - returns: True if the string ends with the given string (using the given case sensitivity), False otherwise.
    public func endsWith(string: String, caseInsensitive: Bool) -> Bool {
        if caseInsensitive {
            return lowercased().hasSuffix(string.lowercased())
        } else {
            return hasSuffix(string)
        }
    }
    /// - returns: True if the given string is contained in the string, False otherwise.
    public func contains(string: String) -> Bool {
        return range(of: string) != nil
    }
    /// - returns: True if the given string is contained in the string (using the given case sensitivity), False otherwise.
    public func contains(string: String, caseInsensitive: Bool) -> Bool {
        return range(of: string, options: caseInsensitive ? .caseInsensitive : []) != nil
    }
    /** The dot (".") in iOS does not match the newline character by default, whereas in Qt the dot will match any character, including the newline character.
        - returns: True if the regular expression is contained in the string, False otherwise.
    */
    public func contains(regex: String) -> Bool {
        return range(of: regex, options: .regularExpression) != nil
    }
    /// - returns: True if the regular expression is contained in the string (using the given case sensitivity), False otherwise.
    public func contains(regex: String, caseInsensitive: Bool) -> Bool {
        let options = NSString.CompareOptions.regularExpression.union(caseInsensitive ? .caseInsensitive : [])
        return range(of: regex, options: options) != nil
    }
    
    /// - returns: If the string is found, the index of its first character, -1 otherwise.
    public func indexOf(string: String) -> Int {
        let index = (self as NSString).range(of: string).location
        if index == NSNotFound {
            return -1
        } else {
            return index
        }
    }
}
