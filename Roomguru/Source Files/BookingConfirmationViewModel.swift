//
//  BookingConfirmationViewModel.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 04/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DateKit

class BookingConfirmationViewModel {
    
    var bookingDurationInMinutes: String {
        return "\(Int(ceil(expectedEventEndDate.timeIntervalSinceDate(entry.event.start)))/60)"
    }
    
    var title: String {
        let name = CalendarPersistenceStore.sharedStore.nameMatchingID(entry.calendarID)
        return entry.event.startTime + " - " + entry.event.endTime
    }
    
    var detailTitle: String {
        return CalendarPersistenceStore.sharedStore.nameMatchingID(entry.calendarID)
    }
    
    let entry: CalendarEntry!
    var canAddMinutes: Bool { return expectedEventEndDate != entry.event.end }
    var canSubstractMinutes: Bool { return expectedEventEndDate != minimumEndDate }
    
    private var expectedEventEndDate: NSDate!
    
    // minimum end date is start date rounded to next 15 minutes: (eg. start date 15:32:23 will return 15:45:00)
    private var minimumEndDate: NSDate {
        return entry.event.start.nextDateWithGranulation(.Minute, multiplier: 15)
    }

    init(entry: CalendarEntry) {
        self.entry = entry
        expectedEventEndDate = (entry.event.duration > Constants.Timeline.DefaultEventDuration) ? minimumEndDate : entry.event.end
    }
    
    func prepareToSave() {
        entry.event.end = expectedEventEndDate
    }

    func isValid() -> Bool {
        if let summary = entry.event.summary {
            return validate(summary)
        }
        return false
    }
    
    func validate(text: String) -> Bool {
        return text.length >= 5
    }
    
    func decreaseBookingTime() {

        let previousRoundedDateTo15Minutes = expectedEventEndDate.previousDateWithGranulation(.Minute, multiplier: 15)
        let timeIntervalFromStartDateToRoundedDate = previousRoundedDateTo15Minutes.timeIntervalSinceDate(entry.event.start)
        
        if timeIntervalFromStartDateToRoundedDate <= Constants.Timeline.MinimumEventDuration {
            expectedEventEndDate = minimumEndDate
        } else {
            expectedEventEndDate = previousRoundedDateTo15Minutes
        }
    }
    
    func increaseBookingTime() {
        
        let nextRoundedDateTo15Minutes = expectedEventEndDate.nextDateWithGranulation(.Minute, multiplier: 15)
        let timeIntervalFromStartDateToRoundedDate = entry.event.end.timeIntervalSinceDate(nextRoundedDateTo15Minutes)
        
        if timeIntervalFromStartDateToRoundedDate <= 0 {
            expectedEventEndDate = entry.event.end
        } else {
            expectedEventEndDate = nextRoundedDateTo15Minutes
        }
    }
}
