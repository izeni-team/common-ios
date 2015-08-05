//
//  ArrayMagic.swift
//  IzeniCommon
//
//  Created by Christopher Bryan Henderson on 4/14/15.
//  Copyright (c) 2015 Izeni, Inc. All rights reserved.
//

import Foundation

public func sum<T where T: IntegerLiteralConvertible, T: Strideable>(list: Array<T>) -> T {
    var s: T = 0
    let zero: T = 0
    for item in list {
        let d = zero.distanceTo(item)
        s += d
    }
    return s
}

public func sum<T, U where U: IntegerLiteralConvertible, U: Strideable>(list: Array<T>, numberForItem: (item: T) -> U) -> U {
    var s: U = 0
    let zero: U = 0
    for item in list {
        let d = zero.distanceTo(numberForItem(item: item))
        s += d
    }
    return s
}

public func max<T where T: Strideable, T: IntegerLiteralConvertible>(list: Array<T>) -> T {
    var highest: T = 0
    for item in list {
        if highest == 0 || item.distanceTo(highest) < 0 {
            highest = item
        }
    }
    return highest
}

public func max<T, U where U: Strideable, U: IntegerLiteralConvertible>(list: Array<T>, numberForItem: (item: T) -> U) -> U {
    var highest: U = 0
    for item in list {
        let n = numberForItem(item: item)
        if highest == 0 || n.distanceTo(highest) < 0 {
            highest = n
        }
    }
    return highest
}

public func min<T where T: Strideable, T: IntegerLiteralConvertible>(list: Array<T>) -> T {
    var lowest: T = 0
    for item in list {
        if lowest == 0 || item.distanceTo(lowest) > 0 {
            lowest = item
        }
    }
    return lowest
}

public func min<T, U where U: Strideable, U: IntegerLiteralConvertible>(list: Array<T>, numberForItem: (item: T) -> U) -> U {
    var lowest: U = 0
    for item in list {
        let n = numberForItem(item: item)
        if lowest == 0 || n.distanceTo(lowest) > 0 {
            lowest = n
        }
    }
    return lowest
}

extension Array {
    func foreach(closure: (item: T) -> Void) {
        for item in self {
            closure(item: item)
        }
    }
}