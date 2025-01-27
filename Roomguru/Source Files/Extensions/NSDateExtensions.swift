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
    case Second, Minute, Hour, Day
    
    var durationRepresentation: Int {
        switch self {
        case .Second: return 1
        case .Minute: return 60
        case .Hour: return 60*60
        case .Day: return 60*60*24
        }
    }
}

enum DateInterpolation {
    case None, Floor, Ceil, Round
    
    func interpolate(value: Double) -> Double {
        switch self {
        case .None: return value
        case .Floor: return floor(value)
        case .Ceil: return ceil(value)
        case .Round: return round(value)
        }
    }
}

extension NSDate {
    
    var dayTimeRange: TimeRange { return (min: midnight, max: hour(23).minute(59).second(59).date) }
    
    func isToday() -> Bool {
        let today = NSDate()
        return isSameDayAs(today)
    }
    
    func roundTo(dateGranulation: DateGranulation, interpolation: DateInterpolation = .Round) -> NSDate {
        let unitDuration = NSTimeInterval(dateGranulation.durationRepresentation)
        let referenceDate = interpolation.interpolate(timeIntervalSinceReferenceDate/unitDuration) * unitDuration
        return NSDate(timeIntervalSinceReferenceDate:referenceDate)
    }
    
    func isSameDayAs(date: NSDate) -> Bool {
        return compare(toDate: date).same
    }
    
    func isEarlierThanToday() -> Bool {
        return self < NSDate()
    }
    
    func nextDateWithGranulation(granulation: DateGranulation, multiplier: Float) -> NSDate {
        let roundTo = NSTimeInterval(Float(granulation.durationRepresentation) * multiplier)
        let timestamp = timeIntervalSince1970
        let next = (timestamp - fmod(timestamp, roundTo)) + roundTo
        
        return NSDate(timeIntervalSince1970: next)
    }
    
    func previousDateWithGranulation(granulation: DateGranulation, multiplier: Float) -> NSDate {
        let roundTo = NSTimeInterval(Float(granulation.durationRepresentation) * multiplier)
        let timestamp = timeIntervalSince1970
        var previous = (timestamp - fmod(timestamp, roundTo))
        if floor(timestamp) - previous == 0 {
            previous -= roundTo
        }
        
        return NSDate(timeIntervalSince1970: previous)
    }
    
    class func timeIntervalBetweenDates(#start: NSDate, end: NSDate) -> NSTimeInterval {
        return ceil(end.timeIntervalSinceDate(start))
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
