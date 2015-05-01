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

    func provideDataForCalendarIDs(calendarIDs: [String], timeRange: TimeRange, completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
        
        let queries: [PageableQuery] = EventsQuery.queriesForCalendarIdentifiers(calendarIDs, withTimeRange: timeRange)
        
        NetworkManager.sharedInstance.chainedRequest(queries, construct: { (query, response: [Event]?) -> [CalendarEntry] in
            
            if let query = query as? EventsQuery, response = response {
                let events = self.onlyActiveEvents(response)
                return CalendarEntry.caledarEntries(query.calendarID, events: events)
            }
            return []
            
            }, success: { [weak self] (result: [CalendarEntry]?) in
                
                var calendarEntriesToReturn: [CalendarEntry] = []
                
                Async.background {
                    if let result = result, calendarEntries = self?.fillActiveEventsWithFreeEvents(result) {
                        calendarEntriesToReturn = calendarEntries
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
    
    func fillActiveEventsWithFreeEvents (entries: [CalendarEntry]) -> [CalendarEntry] {
        let sortedEntries = CalendarEntry.sortedByDate(entries)
        return CalendarEntry.entriesWithFreeGaps(sortedEntries)
    }
}
