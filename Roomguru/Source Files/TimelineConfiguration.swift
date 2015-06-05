//
//  TimelineConfiguration.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 05/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/* NOTICE:
 * If you decide to create struct without defaultConfiguration
 * remember to set ALL variables before usage.
 */

struct TimelineConfiguration {
    
    // Define minimum event duration (in seconds).
    /* NOTICE:
     * Creating minimum event duration longer than time step 
     * will break timeline with free events populate.
     */
    var minimumEventDuration: NSTimeInterval!
    
    // Define defualt event duration (in seconds).
    var defaultEventDuration: NSTimeInterval!
    
    // Default iteration time step (in seconds).
    // It will be used to split timeline into bookable parts.
    var timeStep: NSTimeInterval!
    
    // Time range within you can book events (in seconds).
    var bookingRange: (min: NSTimeInterval, max: NSTimeInterval)!
    
    // Set the days within booking will be possible. 1st - sunday, 7th - saturday
    var bookingDays: [Int]!
    
    // Whether events in the past should be bookable or not
    var bookablePast: Bool!
    
    init(defaultConfiguration: Bool = true) {
        
        if defaultConfiguration {
            self.defualtConfiguration()
        }
    }
}

private extension TimelineConfiguration {
    
    mutating func defualtConfiguration() {
        
        // Set to 15 minutes:
        minimumEventDuration = 60 * 15
        
        // Set to 30 minutes
        defaultEventDuration = 60 * 30
        
        // Set to 30 minutes
        timeStep = 60 * 30
        
        // First available event will be bookable at 7 AM, and the last one at 5 PM
        bookingRange = (60 * 60 * 7, 60 * 60 * 17)
        
        // Bookable only in weekdays:
        bookingDays = [2, 3, 4, 5, 6]
        
        // Do not allow book events in the past
        bookablePast = false
    }
}
