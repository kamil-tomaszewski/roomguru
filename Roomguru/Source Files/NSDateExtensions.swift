//
//  NSDateExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DateKit

enum DateGranulation {
    case Minute, Hour, Day
    
    func interval() -> Int {
        switch self {
        case .Minute: return 60
        case .Hour: return 60*60
        case .Day: return 60*60*24
        }
    }
}

extension NSDate {
    
    func isToday() -> Bool {
        let today = NSDate()
        return isSameDayAs(today)
    }
    
    func isSameDayAs(date: NSDate) -> Bool {
        return days == date.days && months == date.months && years == date.years
    }
    
    func isEarlierThanToday() -> Bool {
        let today = NSDate()
        return isEarlierThan(today)
    }
    
    func isEarlierThan(date: NSDate) -> Bool {
        return compare(date) == .OrderedAscending
    }
    
    func isLaterThan(date: NSDate) -> Bool {
        return compare(date) == .OrderedDescending
    }
    
    func dayTimeRange() -> TimeRange {
        return (min: midnight, max: hour(23).minute(59).second(59).date)
    }
    
    func nextDateWithGranulation(granulation: DateGranulation, multiplier: Float) -> NSDate {
        let roundTo = NSTimeInterval(Float(granulation.interval()) * multiplier)
        let timestamp = timeIntervalSince1970
        let next = (timestamp - fmod(timestamp, roundTo)) + roundTo
        
        return NSDate(timeIntervalSince1970: next)
    }
}

postfix operator ++ {}
postfix func ++ (date: NSDate) -> NSDate {
    return date.days + 1
}

postfix operator -- {}
postfix func -- (date: NSDate) -> NSDate {
    return date.days - 1
}
