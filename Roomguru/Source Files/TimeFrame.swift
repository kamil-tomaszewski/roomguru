//
//  TimeFrame.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum TimeFrameAvailability {
    
    case Available, NotAvailable
}

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

// MARK: Debug

extension TimeFrame: Printable {
    
    var description: String {
        return "start: \(self.startDate), end: \(self.endDate), duration: \(self.duration()), availability: \(self.availability)"
    }
}

extension TimeFrameAvailability: Printable {
    
    var description: String {
        
        switch self {
        case .Available:
            return "Available"
        case .NotAvailable:
            return "Not available"
        }
    }
}
