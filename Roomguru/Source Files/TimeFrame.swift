//
//  Timeframe.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct TimeFrame: Printable {
    
    let startDate: NSDate
    let endDate: NSDate
    let availability: TimeFrameAvailability
    
    var description: String {
        return "start date: \(self.startDate), end date: \(self.endDate), availability: \(self.availability)"
    }
    
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

enum TimeFrameAvailability: Printable {
    
    case Available, NotAvailable
    
    var description: String {
        
        switch self {
        case .Available:
            return "Available"
        case .NotAvailable:
            return "Not available"
        }
    }
}
