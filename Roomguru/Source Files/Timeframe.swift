//
//  Timeframe.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct TimeFrame {
    
    let startDate: NSDate
    let endDate: NSDate
    let availability: TimeFrameAvailability
    
    init(startDate: NSDate, endDate: NSDate, availability: TimeFrameAvailability) {
        self.startDate = startDate
        self.endDate = endDate
        self.availability = availability
    }
    
}

extension TimeFrame {
    
    func duration() -> NSTimeInterval {
        return endDate.timeIntervalSinceDate(startDate)
    }
    
}

struct TimeFrameAvailability {
    
    let Available = "available"
    let NotAvailable = "not available"
    
    subscript(index: Int) -> String {
        get {
            switch index {
                case 1: return self.Available
                case 2: return self.NotAvailable
                default: return self.NotAvailable
            }
        }
    }
    
}
