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
    
    var summary: String = NSLocalizedString("Summary", comment: "")
    
    var title: String {
        get {
            if let startDate = calendarTime.0?.startDate, endDate = calendarTime.0?.endDate {
                let startDateString = timeFormatter.stringFromDate(startDate)
                let endDateString = timeFormatter.stringFromDate(endDate)
                return "Room " + calendarTime.1.roomName() + " | " + startDateString + " - " + endDateString
            }
            return ""
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
        
        configureFormatters()
        setupActualBookingTime()
    }
    
    // MARK: Private
    
    private func configureFormatters() {
        self.dateFormatter.timeZone = NSTimeZone.localTimeZone()
        self.timeFormatter.timeZone = NSTimeZone.localTimeZone()
        self.dateFormatter.dateStyle = .ShortStyle
        self.timeFormatter.timeStyle = .ShortStyle
    }
    
    private func setupActualBookingTime() {
        let today = NSDate()
        let endDate = today.minutes.add(30).date
        let timeFrame = TimeFrame(startDate: today, endDate: endDate, availability: .Available)
        actualBookingTime = (timeFrame, calendarTime.1)
    }
}

extension BookingConfirmationViewModel {
    
    func bookingTimeDuration() -> NSTimeInterval {
        return actualBookingTime.0?.duration() ?? 0
    }
    
    func isValid() -> Bool {
        return summary.length >= 5
    }
    
    func addBookingTimeMinutes(minutes: Int) {
        
        if let actualTimeFrame = actualBookingTime.0 {
            let endDate = actualTimeFrame.endDate.minutes.add(minutes).date
            let timeFrame = TimeFrame(startDate: actualTimeFrame.startDate, endDate: endDate, availability: actualTimeFrame.availability)
            self.actualBookingTime = (timeFrame, actualBookingTime.1)
        }
    }
    
    func canAddMinutes() -> Bool {
        return actualBookingTime.0?.duration() < calendarTime.0?.duration()
    }
    
    func canSubstractMinutes() -> Bool {
        return actualBookingTime.0?.duration() > minimumBookingTime
    }
    
    func confirmBooking() {
        confirmation(actualBookingTime, summary)
    }
}
