//
//  FreeEvent.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 24/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation


class FreeEvent: Event {
    
    var duration: NSTimeInterval = 0.0
    
    init(startDate: NSDate, endDate: NSDate) {
        duration = startDate.timeIntervalSinceDate(endDate)
        
        super.init()
        
        start = startDate
        end = endDate
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        startTime = formatter.stringFromDate(startDate)
        endTime = formatter.stringFromDate(endDate)
        
        formatter.dateFormat = "yyyy-MM-dd"
        let shortDateString = formatter.stringFromDate(startDate)
        if let _shortDate = formatter.dateFromString(shortDateString) {
            shortDate = _shortDate
        }
    }

    required init(json: JSON) {
        super.init(json: json)
    }
}


extension FreeEvent {
    
    /**
    *   This method expects *sorted by date* array of Events
    */
    class func eventsWithFreeGaps(events: [Event]) -> [Event] {
        
        var freeEvents: [Event] = []
        let eventsCount = events.count
        let today = NSDate()
        
        for (index: Int, event: Event) in enumerate(events) {
            let previousIndex = index + 1
            if previousIndex < eventsCount {
                let prevEvent = events[index+1]
                
                if let prevEventEnd = prevEvent.endDate?.date() {
                    if let eventStart = event.startDate?.date() {
                        
                        if !freeEvents.contains(event) {
                            freeEvents.append(event)
                        }
                        
                        if eventStart.day == prevEventEnd.day && eventStart.day >= today.day && eventStart >= today {
                            let timeDiff = eventStart.timeIntervalSinceDate(prevEventEnd)
                            
                            if timeDiff >= 15*60 {
                                freeEvents.append(FreeEvent(startDate: eventStart, endDate: prevEventEnd))
                            }
                        }
                        
                        if !freeEvents.contains(prevEvent) {
                            freeEvents.append(prevEvent)
                        }
                    }
                }
            }
        }
        
        return freeEvents
    }
    
}
