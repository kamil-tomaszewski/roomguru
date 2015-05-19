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
    
    var summary = ""
    
    var title: String {
        get {
            let startDate = calendarTime.0.startDate, endDate = calendarTime.0.endDate
            let startDateString = timeFormatter.stringFromDate(startDate)
            let endDateString = timeFormatter.stringFromDate(endDate)
            let name = CalendarPersistenceStore.sharedStore.nameMatchingID(calendarTime.1)
            return startDateString + " - " + endDateString
        }
    }
    
    var detailTitle: String {
        get {
            return CalendarPersistenceStore.sharedStore.nameMatchingID(calendarTime.1)
        }
    }
    
    private let calendarTime: CalendarTimeFrame
    private var actualBookingTime: CalendarTimeFrame
    
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var timeFormatter: NSDateFormatter = NSDateFormatter()

    private let confirmation: (CalendarTimeFrame, String) -> Void
    
    private let minimumBookingTime = NSTimeInterval(900)
    
    init(calendarTimeFrame: CalendarTimeFrame, onConfirmation: (CalendarTimeFrame, String) -> Void) {
        calendarTime = calendarTimeFrame
        confirmation = onConfirmation
        
        let actualTimeFrame = calendarTimeFrame.0
        let actualStartDate = actualTimeFrame.startDate
        let actualEndDate = actualTimeFrame.duration() > 30*60 ? actualStartDate.minutes + 30 : actualTimeFrame.0.endDate
            
        actualBookingTime = (TimeFrame(startDate: actualStartDate, endDate: actualEndDate, availability: actualTimeFrame.availability), calendarTimeFrame.1)
        configureFormatters()
    }
    
    // MARK: Private
    
    private func configureFormatters() {
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        timeFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateStyle = .ShortStyle
        timeFormatter.timeStyle = .ShortStyle
    }
}

extension BookingConfirmationViewModel {
    
    func bookingTimeDuration() -> NSTimeInterval {
        return actualBookingTime.0.duration()
    }
    
    func isValid() -> Bool {
        return validate(summary)
    }
    
    func validate(text: String) -> Bool {
        return text.length >= 5
    }
    
    func addBookingTimeMinutes(minutes: Int) {
        let actualTimeFrame = actualBookingTime.0
        let endDate = actualTimeFrame.endDate.minutes.add(minutes).date
        let timeFrame = TimeFrame(startDate: actualTimeFrame.startDate, endDate: endDate, availability: actualTimeFrame.availability)
        actualBookingTime = (timeFrame, actualBookingTime.1)
    }
    
    func canAddMinutes() -> Bool {
        return actualBookingTime.0.duration() < calendarTime.0.duration()
    }
    
    func canSubstractMinutes() -> Bool {
        return actualBookingTime.0.duration() > minimumBookingTime
    }
    
    func confirmBooking() {
        confirmation(actualBookingTime, summary)
    }
}
