//
//  NSDateExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DateKit

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
}
