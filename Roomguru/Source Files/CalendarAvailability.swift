//
//  CalendarAvailability.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class CalendarAvailability: NSObject {
    
    let calendar: String
    let timeMin: NSDate
    let timeMax: NSDate
    
    init(calendar: String, timeMin: NSDate, timeMax: NSDate) {
        self.calendar = calendar
        self.timeMin = timeMin
        self.timeMax = timeMax
        
        super.init()
    }
    
}
