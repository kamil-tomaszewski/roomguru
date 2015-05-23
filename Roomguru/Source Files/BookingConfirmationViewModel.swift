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
    
    var bookingDurationInMinutes: String { return "\(Int(bookingDuration/60))" }
    var canAddMinutes: Bool { return bookingDuration < entry.event.duration }
    var canSubstractMinutes: Bool { return bookingDuration > minimumEventDuration }
    
    var title: String {
        let name = CalendarPersistenceStore.sharedStore.nameMatchingID(entry.calendarID)
        return entry.event.startTime + " - " + entry.event.endTime
    }
    
    var detailTitle: String {
        return CalendarPersistenceStore.sharedStore.nameMatchingID(entry.calendarID)
    }
    
    private var bookingDuration: NSTimeInterval!
    private let minimumEventDuration = Constants.Timeline.MinimumEventDuration
    
    let entry: CalendarEntry!
    
    init(entry: CalendarEntry) {
        self.entry = entry
        self.bookingDuration = (entry.event.duration < Constants.Timeline.DefaultEventDuration) ? entry.event.duration : Constants.Timeline.DefaultEventDuration
    }
}

extension BookingConfirmationViewModel {

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
        
        if !canSubstractMinutes {
            return
        }
        bookingDuration = bookingDuration - minimumEventDuration
    }
    
    func increaseBookingTime() {
        
        if !canAddMinutes {
            return
        }
        
        var newBookingDuration = bookingDuration + minimumEventDuration
        
        if newBookingDuration > entry.event.duration {
            newBookingDuration = entry.event.duration
        }
        bookingDuration = newBookingDuration
    }
}
