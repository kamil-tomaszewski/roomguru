//
//  FreeEventsProvider.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 06/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class FreeEventsProvider {
    
    class func fillActiveEventsWithFreeEvents(activeEntries: [CalendarEntry], inTimeRange timeRange: TimeRange) -> [CalendarEntry] {
        
        let sortedEntries = CalendarEntry.sortedByDate(activeEntries)
        let timeStep = Constants.Timeline.TimeStep
        
        var entries: [CalendarEntry] = []
        var referenceDate = timeRange.min
        var index = 0
        
        while referenceDate < timeRange.max {

            // there is no entry after reference date. Means all active entries has beed populated:
            if index == sortedEntries.count {
                
                let nextHalfHourDate = referenceDate.nextDateWithGranulation(.Hour, multiplier: 0.5)
                let timeBetweenReferenceDateAndNextHalfHour = nextHalfHourDate.timeIntervalSinceDate(referenceDate)
                
                addFreeEventCalendarEntryToEntries(&entries, withStartDate: referenceDate, endDate: referenceDate.dateByAddingTimeInterval(timeBetweenReferenceDateAndNextHalfHour))
                increase(&referenceDate, by: timeBetweenReferenceDateAndNextHalfHour)
               
            // active entries still exists and should be populated in entries array:
            } else {
            
                let entry = sortedEntries[index]
                let timeBetweenReferenceDateAndTheClosestEntry = ceil(entry.event.start.timeIntervalSinceDate(referenceDate))
                
                // there is entry in less than next timeStep seconds:
                if timeBetweenReferenceDateAndTheClosestEntry < timeStep && timeBetweenReferenceDateAndTheClosestEntry > 0 {
                    
                    addFreeEventCalendarEntryToEntries(&entries, withStartDate: referenceDate, endDate: entry.event.start)
                    increase(&referenceDate, by: timeBetweenReferenceDateAndTheClosestEntry)
                    
                // there is no entry in next timeStep seconds:
                } else if timeBetweenReferenceDateAndTheClosestEntry >= timeStep {
                    
                    let nextHalfHourDate = referenceDate.nextDateWithGranulation(.Hour, multiplier: 0.5)
                    let timeBetweenReferenceDateAndNextHalfHour = ceil(nextHalfHourDate.timeIntervalSinceDate(referenceDate))
                    
                    // one of the event ended earlier than in half an hour (google speedy meetings):
                    if timeBetweenReferenceDateAndNextHalfHour < timeStep {
                        
                        addFreeEventCalendarEntryToEntries(&entries, withStartDate: referenceDate, endDate: referenceDate.dateByAddingTimeInterval(timeBetweenReferenceDateAndNextHalfHour))
                        increase(&referenceDate, by: timeBetweenReferenceDateAndNextHalfHour)

                    } else {
                        addFreeEventCalendarEntryToEntries(&entries, withStartDate: referenceDate, endDate: referenceDate.dateByAddingTimeInterval(timeStep))
                        increase(&referenceDate)
                    }
                    
                // add event cause it's event time frame:
                } else {
                    entries.append(entry)
                    increase(&referenceDate, by: entry.event.duration)
                    
                    index++
                }
            }
        }
        return entries
    }
}

private extension FreeEventsProvider {
    
    class func addFreeEventCalendarEntryToEntries(inout entries: [CalendarEntry], var withStartDate startDate: NSDate, endDate: NSDate)  {
        
        // cannot book in not declared days
        let weekday = NSCalendar.currentCalendar().component(NSCalendarUnit.CalendarUnitWeekday, fromDate: startDate)
        if !contains(Constants.Timeline.BookingDays, weekday) {
            return
        }
        
        // cannot book earlier than defined
        if startDate.timeIntervalSinceDate(startDate.midnight) < Constants.Timeline.BookingRange.min {
            return
        }
        
        // cannot book later than defined
        if startDate.timeIntervalSinceDate(startDate.midnight) > Constants.Timeline.BookingRange.max {
            return
        }
        
        // If earlier than now, change start date of event.
        // If will pass second condition, it means startDate is around current hour.
        // It it will be past, eventDuration will give minuse value, so next condition will break adding event.
        if startDate.isEarlierThanToday() {
            startDate = NSDate()
        }
        
        let eventDuration = ceil(endDate.timeIntervalSinceDate(startDate))
        
        // cannot be shorter than MinimumEventDuration
        if eventDuration < Constants.Timeline.MinimumEventDuration {
            return
        }
        
        let freeEvent = FreeEvent(startDate: startDate, endDate: endDate)
        entries.append(CalendarEntry(calendarID: "", event: freeEvent))
    }
    
    class func increase(inout date: NSDate, by timeInterval: NSTimeInterval = Constants.Timeline.TimeStep) {
        date = date.dateByAddingTimeInterval(timeInterval)
    }
}
