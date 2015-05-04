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

    func provideCalendarEntriesForCalendarIDs(calendarIDs: [String], timeRange: TimeRange, onlyRevocable: Bool, completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
        
        let queries: [PageableQuery] = EventsQuery.queriesForCalendarIdentifiers(calendarIDs, withTimeRange: timeRange)
        
        NetworkManager.sharedInstance.chainedRequest(queries, construct: { (query, response: [Event]?) -> [CalendarEntry] in
            
            if let query = query as? EventsQuery, response = response {
                var events:[Event] = []
                if onlyRevocable{
                    events = self.onlyCreatedByUserActiveEvents(response)
                } else {
                    events = self.onlyActiveEvents(response)
                }
                return CalendarEntry.caledarEntries(query.calendarID, events: events)
            }
            return []
            
            }, success: { [weak self] (result: [CalendarEntry]?) in
                
                var calendarEntriesToReturn: [CalendarEntry] = []
                
                Async.background {
                    if onlyRevocable{
                        if let result = result {
                                calendarEntriesToReturn = CalendarEntry.sortedByDate(result)
                            }
                    } else {
                        if let result = result, calendarEntries = self?.fillActiveEventsWithFreeEvents(result) {
                                calendarEntriesToReturn = calendarEntries
                        }
                    }
                }.main {
                    completion(calendarEntries: calendarEntriesToReturn, error: nil)
                }
                
            }, failure: { error in
                completion(calendarEntries: [], error: error)
        })
    }

}

private extension EventsProvider {
    
    func onlyActiveEvents (events: [Event]) -> [Event] {
        return events.filter{ !$0.isCanceled() }
    }
    
    func onlyCreatedByUserActiveEvents (events: [Event]) -> [Event] {
        let userEmail = UserPersistenceStore.sharedStore.user?.email
        return events.filter{ !$0.isCanceled() && $0.creator?.email == userEmail}
    }

    func fillActiveEventsWithFreeEvents (entries: [CalendarEntry]) -> [CalendarEntry] {
        let sortedEntries = CalendarEntry.sortedByDate(entries)
        return CalendarEntry.entriesWithFreeGaps(sortedEntries)
    }
}
