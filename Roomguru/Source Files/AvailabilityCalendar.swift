//
//  AvailabilityCalendar.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class AvailabilityCalendar: NSObject {
    
    let calendarID: String
    let startDate: NSDate
    let endDate: NSDate
    var timeFrames: [TimeFrame]
    
    override var description: String {
        var customDescription = "calendar id: \(self.calendarID), time frames:\n"
        
        for timeFrame in timeFrames {
            customDescription += "\(timeFrame)\n"
        }
        
        return customDescription
    }
    
    init(calendarID: String, startDate: NSDate, endDate: NSDate, timeFrames: [TimeFrame]) {
        self.calendarID = calendarID
        self.startDate = startDate
        self.endDate = endDate
        self.timeFrames = timeFrames
        
        super.init()
        
        self.fillWithAvailableTimeFrames()
    }
    
    // sketches for further implementation
    
    private func fillWithAvailableTimeFrames() {
        // self.timeFrames should be filled with *available* TimeFrame instances between not available ones (this will be seen locally only); this would make easy to check (just iterate through array) if we have a free 30 minutes time window to book a room.
    }
    
    func closestFreeTimeFrame() -> TimeFrame? {
        // returns the closest (in terms of time) free time frame (if we have one - calendar may be filled fully by other bookings)
        return nil
    }
    
}
