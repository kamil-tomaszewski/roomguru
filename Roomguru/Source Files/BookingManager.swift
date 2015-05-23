//
//  BookingManager.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DateKit
import SwiftyJSON

class BookingManager: NSObject {
    
    class func firstBookableCalendarEntry(completion: (entry: CalendarEntry?, error: NSError?) -> Void) {
        
        bookableCalendarEntries { (entries, error) in
            
            if let error = error {
                completion(entry: nil, error: error)
                return
            } else if entries == nil {
                completion(entry: nil, error: nil)
                return
            }
            
            // Take calendar entries from one calendar depending on first element, which is the first available free event
            let freeCalendarEntriesWithSameCalendarID = entries!.filter { entries!.first?.calendarID == $0.calendarID }
            
            // No result found:
            if freeCalendarEntriesWithSameCalendarID.isEmpty {
                completion(entry: nil, error: nil)
                return
            }
            
            // Calendar ID and start event is known:
            let freeEventStartDate = freeCalendarEntriesWithSameCalendarID.first!.event.start
            let calendarID = freeCalendarEntriesWithSameCalendarID.first!.calendarID
            
            var freeEventEndDate: NSDate!
            
            // look for end of free event:
            for (index, freeCalendarEntry) in enumerate(freeCalendarEntriesWithSameCalendarID) {
                
                if index == freeCalendarEntriesWithSameCalendarID.count - 1 {
                    freeEventEndDate = freeCalendarEntry.event.end
                    break
                }
                
                if freeCalendarEntry.event.end != freeCalendarEntriesWithSameCalendarID[index + 1].event.start {
                    freeEventEndDate = freeCalendarEntry.event.end
                    break
                }
            }
            
            // return calendar entry with time frames and calendar ID:
            let freeEvent = FreeEvent(startDate: freeEventStartDate, endDate: freeEventEndDate)
            let freeCalendarEntry = CalendarEntry(calendarID: calendarID, event: freeEvent)
            completion(entry: freeCalendarEntry, error: nil)
        }
    }
    
    class func bookableCalendarEntries(completion: (entries: [CalendarEntry]?, error: NSError?) -> Void) {
        
        let allRooms = CalendarPersistenceStore.sharedStore.rooms().map { $0.id }
        let query = FreeBusyQuery(calendarsIDs: allRooms)
        
        let eventsProvider = EventsProvider(calendarIDs: allRooms, timeRange: NSDate().dayTimeRange)
        eventsProvider.activeCalendarEntriesWithCompletion { (calendarEntries, error) -> Void in
            
            if let error = error {
                completion(entries: nil, error: error)
                return
            }
            
            // Gather only free events and sort them by date:
            var freeCalendarEntries = calendarEntries.filter { $0.event is FreeEvent }
            freeCalendarEntries.sort { $0.event.start <= $1.event.start }
            
            completion(entries: freeCalendarEntries, error: nil)
        }
    }
    
    class func bookCalendarEntry(calendarEntry: CalendarEntry, completion: (event: Event?, error: NSError?) -> Void) {

        let query = BookingQuery(quickCalendarEntry: calendarEntry)
        NetworkManager.sharedInstance.request(query, success: { response in
            
            if let response = response {
                let event = Event(json: response)
                completion(event: event, error: nil)
            } else {
                let error = NSError(message: NSLocalizedString("Problem booking event occurred", comment: ""))
                completion(event: nil, error: error)
            }
            
            }, failure: { error in
                completion(event: nil, error: error)
        })
    }
    
    class func revokeEvent(eventID: String, userEmail: String, completion: (success: Bool, error: NSError?) -> Void) {
        let query = RevokeQuery(eventID: eventID, userEmail: userEmail)
        NetworkManager.sharedInstance.request(query, success: { response in
            completion(success: true, error: nil)
            }, failure: { error in
            completion(success: false, error: error)
        })
    }
}
