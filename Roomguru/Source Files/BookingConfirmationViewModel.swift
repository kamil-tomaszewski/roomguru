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
        return "\(Int(NSDate.timeIntervalBetweenDates(start: entry.event.start, end: expectedEventEndDate))/60)"
    }
    
    var title: String {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        
        let name = CalendarPersistenceStore.sharedStore.nameMatchingID(entry.calendarID)
        let startTime = formatter.stringFromDate(entry.event.start.roundTo(.Minute))
        return startTime + " - " + entry.event.endTime
    }
    
    var detailTitle: String {
        return CalendarPersistenceStore.sharedStore.nameMatchingID(entry.calendarID)
    }
    
    let entry: CalendarEntry!
    
    var minimumEventDuration: NSTimeInterval { return Constants.Timeline.MinimumEventDuration }
    
    var canAddMinutes: Bool { return expectedEventEndDate != entry.event.end }
    var canSubstractMinutes: Bool {
        
        let willNewEndDatePassEventDurationRequirement = NSDate.timeIntervalBetweenDates(start: entry.event.start, end: expectedEventEndDate.minutes - 15) >= minimumEventDuration
        return expectedEventEndDate >= minimumEndDate && willNewEndDatePassEventDurationRequirement
    }
    
    private var expectedEventEndDate: NSDate!
    
    // minimum end date is start date rounded to next 15 minutes: (eg. start date 15:32:23 will return 15:45:00)
    private var minimumEndDate: NSDate {
        
        let nextDateRoundedTo15Minutes = entry.event.start.nextDateWithGranulation(.Minute, multiplier: 15)
        let isTimeIntervalFromStartDateToNextRoundedDateAllowed = NSDate.timeIntervalBetweenDates(start: entry.event.start, end: nextDateRoundedTo15Minutes) > Constants.Timeline.DefaultEventDuration
        
        if isTimeIntervalFromStartDateToNextRoundedDateAllowed {
            return nextDateRoundedTo15Minutes
        }
        return nextDateRoundedTo15Minutes.minutes + 15
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
        let timeIntervalFromStartDateToRoundedDate = NSDate.timeIntervalBetweenDates(start: entry.event.start, end: previousRoundedDateTo15Minutes)
        
        if timeIntervalFromStartDateToRoundedDate < minimumEventDuration {
            expectedEventEndDate = minimumEndDate
        } else {
            expectedEventEndDate = previousRoundedDateTo15Minutes
        }
    }
    
    func increaseBookingTime() {

        let nextRoundedDateTo15Minutes = expectedEventEndDate.nextDateWithGranulation(.Minute, multiplier: 15)
        let timeIntervalFromStartDateToRoundedDate = NSDate.timeIntervalBetweenDates(start: nextRoundedDateTo15Minutes, end: entry.event.end)
        
        if timeIntervalFromStartDateToRoundedDate < minimumEventDuration {
            expectedEventEndDate = entry.event.end
        } else {
            expectedEventEndDate = nextRoundedDateTo15Minutes
        }
    }
}
