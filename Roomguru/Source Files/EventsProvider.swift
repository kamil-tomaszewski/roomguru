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

private enum FilterType {
    case Active, ActiveWhereUserIsAttendeeOrCreator
}

class EventsProvider {
    
    private let timeRange: TimeRange
    private var filterType: FilterType!
    
    let calendarIDs: [String]
    
    init(calendarIDs: [String], timeRange: TimeRange) {
        self.timeRange = timeRange
        self.calendarIDs = calendarIDs
    }
    
    func activeCalendarEntriesWithCompletion(completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
        
        filterType = .Active
        
        entriesWithCalendarIDs(calendarIDs, timeRange: timeRange) { (result, error) in
            
            var calendarEntriesToReturn: [CalendarEntry] = []
            
            Async.background {
                if let entries = result {
                    calendarEntriesToReturn = FreeEventsProvider().populateEntriesWithFreeEvents(entries, inTimeRange: self.timeRange, usingCalenadIDs: self.calendarIDs)
                }
            }.main {
                completion(calendarEntries: calendarEntriesToReturn, error: error)
            }
        }
    }
    
    func userActiveCalendarEntriesWithCompletion(completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
        
        filterType = .ActiveWhereUserIsAttendeeOrCreator
        
        entriesWithCalendarIDs(calendarIDs, timeRange: timeRange) { (result, error) in
            
            var calendarEntriesToReturn: [CalendarEntry] = []

            Async.background {
                if let result = result {
                    calendarEntriesToReturn = CalendarEntry.sortedByDate(result)
                }
            }.main {
                completion(calendarEntries: calendarEntriesToReturn, error: error)
            }
        }
    }
}

private extension EventsProvider {
    
    func entriesWithCalendarIDs(calendarIDs: [String], timeRange: TimeRange, completion: (result: [CalendarEntry]?, error: NSError?) -> Void) {
        
        let queries: [PageableQuery] = EventsQuery.queriesForCalendarIdentifiers(calendarIDs, withTimeRange: timeRange)
        
        NetworkManager.sharedInstance.chainedRequest(queries, construct: { (query, response: [Event]?) -> [CalendarEntry] in
            
            return self.constructChainedRequestWithQuery(query, response: response)
            
            }, success: { [weak self] (result: [CalendarEntry]?) in
                completion(result: result, error: nil)
                
            }, failure: { error in
                completion(result: [], error: error)
        })
    }
    
    func constructChainedRequestWithQuery(query: PageableQuery, response: [Event]?) -> [CalendarEntry] {
        
        if let query = query as? EventsQuery, response = response {
            var events: [Event] = []
            
            if filterType == .Active {
                events = self.onlyActiveEvents(response)
            } else {
                events = self.onlyActiveEventsWhereUserIsAttendee(response)
            }

            return CalendarEntry.caledarEntries(query.calendarID, events: events)
        }
        return []
    }
    
    func onlyActiveEvents(events: [Event]) -> [Event] {
        return events.filter{ !$0.isCanceled() }
    }
    
    func onlyActiveEventsWhereUserIsAttendee(events: [Event]) -> [Event] {
        let userEmail = UserPersistenceStore.sharedStore.user?.email
        return onlyActiveEvents(events).filter {
            
            // is user an attendee:
            let isAttendee = !$0.attendees.filter {
                $0.email == userEmail
                
                if let email = $0.email, userEmail = userEmail {
                    return email.isEqualToEmail(userEmail, comparisionPart: .Local)
                }
                return false
            }.isEmpty
            

            // is user creator of an event:
            var isCreator = false
            if let email = $0.creator?.email, userEmail = userEmail {
                isCreator = email.isEqualToEmail(userEmail, comparisionPart: .Local)
            }
            
            return isCreator || isAttendee
        }
    }
}
