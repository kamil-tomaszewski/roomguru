//
//  TimelineConfiguration.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 05/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct TimelineConfiguration {
    
    var minimumEventDuration: NSTimeInterval!
    var defaultEventDuration: NSTimeInterval!
    var timeStep: NSTimeInterval!
    
    // Time range within you can book events.
    var bookingRange: (min: NSTimeInterval, max: NSTimeInterval)!
    
    // Set the days within booking will be possible. 1st - sunday, 7th - saturday
    var bookingDays: [Int]!
    
    init(defaultConfiguration: Bool = true) {
        
        if defaultConfiguration {
            self.defualtConfiguration()
        }
    }
}

private extension TimelineConfiguration {
    
    mutating func defualtConfiguration() {
        
        // set to 15 minutes:
        minimumEventDuration = 60*15
        
        // set to 30 minutes
        defaultEventDuration = 60*30
        
        // set to 30 minutes
        timeStep = 60*30
        
        // First available event will be bookable at 7 AM, and the last one at 5 PM
        bookingRange = (60*60*7, 60*60*17)
        
        // Bookable on in weekdays:
        bookingDays = [2, 3, 4, 5, 6]
    }
}
