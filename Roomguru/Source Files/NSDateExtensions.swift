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
        return days == today.days && months == today.months && years == today.years
    }
    
    func isEarlierThanToday() -> Bool {
        let today = NSDate()
        return compare(today) == .OrderedAscending
    }
}
