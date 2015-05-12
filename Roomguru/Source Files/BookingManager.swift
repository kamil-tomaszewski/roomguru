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
import SwiftyJSON

class BookingManager: NSObject {
    
    class func findClosestAvailableRoom(completion: (calendarTime: CalendarTimeFrame?, error: NSError?) -> Void) {
        
        let allRooms = CalendarPersistenceStore.sharedStore.rooms().map {$0.id }
        let query = FreeBusyQuery(calendarsIDs: allRooms)
        
        NetworkManager.sharedInstance.request(query, success: { response in
            
            var calendars: [AvailabilityCalendar] = []
            
            if let calendarsFreeBusyDictionary = response?["calendars"].dictionaryValue {
                for calendar in calendarsFreeBusyDictionary {
                    
                    let calendarJSON: [String : JSON] = calendar.1.dictionaryValue
                    
                    if let timeFrames: [TimeFrame] = TimeFrame.map(calendarJSON["busy"]?.arrayValue) {
                        calendars.append(AvailabilityCalendar(calendarID: calendar.0, timeFrames: timeFrames))
                    }
                }
                
                if calendars.isEmpty {
                    calendars.append(AvailabilityCalendar(calendarID: calendarsFreeBusyDictionary.keys.first as String!, timeFrames: []))
                }
                
            } else {
                let message = NSLocalizedString("Failed retrieving data", comment: "")
                completion(calendarTime: nil, error: NSError(message: message))
                return
            }
            
            if let closestFreeTime = self.closestFreeTimeFrameInCalendars(calendars) {
                completion(calendarTime: closestFreeTime, error: nil)
            } else {
                let message = NSLocalizedString("No free rooms from", comment: "") + " \(query.startDate) " + NSLocalizedString("to", comment: "") + " \(query.endDate)"
                completion(calendarTime: nil, error: NSError(message: message))
            }
            
            }, failure: { error in
                completion(calendarTime: nil, error: error)
            }
        )
    }
    
    class func bookTimeFrame(calendarTime: CalendarTimeFrame, summary: String, success: (event: Event) -> Void, failure: ErrorBlock) {

        let query = BookingQuery(calendarTimeFrame: calendarTime, summary: summary)
        
        NetworkManager.sharedInstance.request(query, success: { response in
            
            if let response = response {
                let event = Event(json: response)
                success(event: event)
            } else {
                let message = NSLocalizedString("Problem booking event occurred", comment: "")
                let error = NSError(message: message)
                failure(error: error)
            }
            
        }, failure: failure)
    }
    
    class func revokeEvent(eventID: String, userEmail: String, completion: (success: Bool, error: NSError?) -> ()) {
        let query = RevokeQuery(eventID: eventID, userEmail: userEmail)
        NetworkManager.sharedInstance.request(query, success: { response in
            completion(success: true, error: nil)
            }, failure: { error in
            completion(success: false, error: error)
        })
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
            $0?.0.startDate <= $1?.0.startDate
        }
        
        return frames[0]
    }
}
