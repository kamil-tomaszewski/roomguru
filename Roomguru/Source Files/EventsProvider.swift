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
    
    private var timeRange: TimeRange!
    var calendarIDs: [String] = []

    func calendarEntriesForTimeRange(timeRange: TimeRange, completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
        
        entriesWithCalendarIDs(calendarIDs, timeRange: timeRange, revocable: false) { [weak self] (result, error) in
            
            var calendarEntriesToReturn: [CalendarEntry] = []
            
            Async.background {
                if let activeEvents = result {
                    calendarEntriesToReturn = FreeEventsProvider.fillActiveEventsWithFreeEvents(activeEvents, inTimeRange: timeRange)
                }
            }.main {
                completion(calendarEntries: calendarEntriesToReturn, error: error)
            }
        }
    }
    
    func revocableCalendarEntriesForTimeRange(timeRange: TimeRange, completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
        
        entriesWithCalendarIDs(calendarIDs, timeRange: timeRange, revocable: true) { (result, error) in
            
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
    
    func entriesWithCalendarIDs(calendarIDs: [String], timeRange: TimeRange, revocable: Bool, completion: (result: [CalendarEntry]?, error: NSError?) -> Void) {
        
        self.timeRange = timeRange
        let queries: [PageableQuery] = EventsQuery.queriesForCalendarIdentifiers(calendarIDs, withTimeRange: timeRange)
        
        NetworkManager.sharedInstance.chainedRequest(queries, construct: { (query, response: [Event]?) -> [CalendarEntry] in
            
            return self.constructChainedRequestWithQuery(query, response: response, revocable: revocable)
            
            }, success: { [weak self] (result: [CalendarEntry]?) in
                completion(result: result, error: nil)
                
            }, failure: { error in
                completion(result: [], error: error)
        })
    }
    
    func constructChainedRequestWithQuery(query: PageableQuery, response: [Event]?, revocable: Bool) -> [CalendarEntry] {
        
        if let query = query as? EventsQuery, response = response {
            var events: [Event] = []
            
            if revocable {
                events = self.onlyActiveEventsWhereUserIsAttendee(response)
            } else {
                events = self.onlyActiveEvents(response)
            }
            return CalendarEntry.caledarEntries(query.calendarID, events: events)
        }
        return []
    }
    
    func onlyActiveEvents(events: [Event]) -> [Event] {
        return events.filter{ !$0.isCanceled() }
    }
    
    func onlyCreatedByUserActiveEvents(events: [Event]) -> [Event] {
        let userEmail = UserPersistenceStore.sharedStore.user?.email
        return onlyActiveEvents(events).filter { $0.creator?.email == userEmail }
    }
    
    func onlyActiveEventsWhereUserIsAttendee(events: [Event]) -> [Event] {
        let userEmail = UserPersistenceStore.sharedStore.user?.email
        return onlyActiveEvents(events).filter {
            
            var isAttendee = false
            
            if let attendees = $0.attendees {
                isAttendee = !attendees.filter { $0.email == userEmail }.isEmpty
            }
            
            return $0.creator?.email == userEmail || isAttendee
        }
    }
}
