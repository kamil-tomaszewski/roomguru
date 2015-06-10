//
//  EventsProvider.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 01/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DateKit
import Async

class EventsProvider {
    
    private let timeRange: TimeRange
    
    let calendarIDs: [String]
    var networkCooperator = EventsProviderNetworkCooperator()
    
    init(calendarIDs: [String], timeRange: TimeRange) {
        self.timeRange = timeRange
        self.calendarIDs = calendarIDs
    }
    
    func activeCalendarEntriesWithCompletion(completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
        
        networkCooperator.entriesWithCalendarIDs(calendarIDs, timeRange: timeRange) { (entries, error) in
            
            var calendarEntriesToReturn: [CalendarEntry] = []
            
            Async.background {
                if let entries = entries {
                    let filteredEntries = self.onlyActiveEntries(entries)
                    calendarEntriesToReturn = FreeEventsProvider().populateEntriesWithFreeEvents(filteredEntries, inTimeRange: self.timeRange, usingCalenadIDs: self.calendarIDs)
                }
            }.main {
                completion(calendarEntries: calendarEntriesToReturn, error: error)
            }
        }
    }
    
    func userActiveCalendarEntriesWithCompletion(completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
        
        networkCooperator.entriesWithCalendarIDs(calendarIDs, timeRange: timeRange) { (entries, error) in
            
            var calendarEntriesToReturn: [CalendarEntry] = []

            Async.background {
                if let entries = entries {
                    let filteredEntries = self.onlyActiveEntriesWhereUserIsAttendee(entries)
                    calendarEntriesToReturn = CalendarEntry.sortedByDate(filteredEntries)
                }
            }.main {
                completion(calendarEntries: calendarEntriesToReturn, error: error)
            }
        }
    }
}

private extension EventsProvider {
    
    func onlyActiveEntries(entries: [CalendarEntry]) -> [CalendarEntry] {
        return entries.filter{ !$0.event.isCanceled() }
    }
    
    func onlyActiveEntriesWhereUserIsAttendee(entries: [CalendarEntry]) -> [CalendarEntry] {
        let userEmail = UserPersistenceStore.sharedStore.user?.email
        
        return onlyActiveEntries(entries).filter {
            
            // is user an attendee:
            let isAttendee = !$0.event.attendees.filter {
                $0.email == userEmail
                
                if let email = $0.email, userEmail = userEmail {
                    return email.isEqualToEmail(userEmail, comparisionPart: .Local)
                }
                return false
            }.isEmpty
            

            // is user creator of an event:
            var isCreator = false
            if let email = $0.event.creator?.email, userEmail = userEmail {
                isCreator = email.isEqualToEmail(userEmail, comparisionPart: .Local)
            }
            
            return isCreator || isAttendee
        }
    }
}
