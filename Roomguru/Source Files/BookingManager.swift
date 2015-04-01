//
//  BookingManager.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DateKit
import SwiftyUserDefaults

class BookingManager: NSObject {
    
    class func findClosestAvailableRoom(success: (calendarTime: CalendarTimeFrame) -> Void, failure: ErrorBlock) {
        
        let allRooms = [Room.Aqua, Room.Cold, Room.Middle]
        let query = FreeBusyQuery(calendarsIDs: allRooms)

        NetworkManager.sharedInstance.request(query, success: { (response: JSON?) -> () in
                        
            var calendars: [AvailabilityCalendar] = []
            
            if let _calendarsFreeBusyDictionary = response?["calendars"].dictionaryValue {
                for calendar in _calendarsFreeBusyDictionary {
                    
                    let calendarJSON: [String : JSON] = calendar.1.dictionaryValue
                    
                    if let timeFrames: [TimeFrame] = TimeFrame.map(calendarJSON["busy"]?.arrayValue) {
                        calendars.append(AvailabilityCalendar(calendarID: calendar.0, timeFrames: timeFrames))
                    }
                }
                
                if calendars.count == 0 {
                    calendars.append(AvailabilityCalendar(calendarID: _calendarsFreeBusyDictionary.keys.first as String!, timeFrames: []))
                }

            } else {
                let message = NSLocalizedString("Failed retrieving data", comment: "")
                failure(error: NSError(message: message))
                return
            }
            
            if let closestFreeTime = self.closestFreeTimeFrameInCalendars(calendars) {
                success(calendarTime: closestFreeTime)
            } else {
                let message = NSLocalizedString("No free rooms from", comment: "") + " \(query.startDate) " + NSLocalizedString("to", comment: "") + " \(query.endDate)"
                failure(error: NSError(message: message))
            }
            
        }, failure: failure)
    }
    
    class func bookTimeFrame(calendarTime: CalendarTimeFrame, summary: String, success: (event: Event) -> Void, failure: ErrorBlock) {

        let query = BookingQuery(calendarTime)
        query.summary = summary
        
        NetworkManager.sharedInstance.request(query, success: { (response) in
            
            if let _response = response {
                let event = Event(json: _response)
                success(event: event)
            } else {
                let message = NSLocalizedString("Problem booking event occurred", comment: "")
                let error = NSError(message: message)
                failure(error: error)
            }
            
        }, failure: failure)
    }
    
    class func revokeCalendarEntry(entry: CalendarEntry, success: VoidBlock, failure: ErrorBlock) {
        let query = RevokeQuery(entry)
        NetworkManager.sharedInstance.request(query, success: { (response) -> () in
            success()
        }, failure: failure)   
    }
}

extension BookingManager {
    
    class func closestFreeTimeFrameInCalendars(calendars: [AvailabilityCalendar]) -> CalendarTimeFrame? {
        
        if calendars.isEmpty { return nil }
        
        var frames = calendars.map { $0.closestFreeTimeFrame() }.filter { $0 != nil }
        
        if frames.isEmpty {
            let now = NSDate()
            let endDate = now.tomorrow.midnight.seconds - 1
            let timeFrame = TimeFrame(startDate: now, endDate: endDate , availability: .Available)
            return (timeFrame, calendars[0].calendarID)
        }
        
        frames.sort {
            $0?.0?.startDate <= $1?.0?.startDate
        }
        
        return frames[0]
    }
}


// MARK: Saving booked calendar entry

extension BookingManager {
    
    class func save(entry: CalendarEntry) {
        let entryData = NSKeyedArchiver.archivedDataWithRootObject(entry)
        Defaults["recently_booked_entry"] = entryData
        Defaults.synchronize()
    }
    
    class func restoreRecentlyBookedEntry() -> CalendarEntry? {
        if let entryData = Defaults["recently_booked_entry"].data {
            return NSKeyedUnarchiver.unarchiveObjectWithData(entryData) as? CalendarEntry
        }
        
        return nil
    }
    
    class func clearRecentlyBookedEntry() {
        Defaults["recently_booked_entry"] = nil
    }
    
    class func hasRecentlyBookedEvent() -> Bool {
        if Defaults.hasKey("recently_booked_entry") {
            if let endDate = restoreRecentlyBookedEntry()?.event.endDate?.date() {
                return  NSDate() <= endDate
            }
        }
        
        return false
    }
}
