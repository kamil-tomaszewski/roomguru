//
//  EditEventNetworkCooperator.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 24/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DateKit
import SwiftyJSON

class EditEventNetworkCooperator {
    
    let eventQuery: EventQuery
    private let currentEditingEventInitialStartDate, currentEditingEventInitialEndDate: NSDate
    
    init(query: EventQuery) {
        eventQuery = query
        currentEditingEventInitialStartDate = query.startDate
        currentEditingEventInitialEndDate = query.endDate
    }
    
    func saveEvent(completion: (event: Event?, error: NSError?) -> Void) {
        
        checkEventsAvailability() { (available, error) in
            
            if let error = error {
                completion(event: nil, error: error)
                return
            }
            
            self.save() { (event, error) in
            
                if let error = error {
                    let message = NSLocalizedString("There was a problem with creating your event. Please try again later.", comment: "")
                    completion(event: nil, error: NSError(message: message))

                } else if let event = event {
                    completion(event: event, error: nil)
                    
                } else {
                    completion(event: nil, error: nil)
                }
            }
        }
    }
}

private extension EditEventNetworkCooperator {
    
    func save(completion: (event: Event?, error: NSError?) -> Void) {
        
        NetworkManager.sharedInstance.request(eventQuery, success: { response in
            
            if var response = response {
                
                response["attendees"] = self.fixResponse(response)
                let event = Event(json: response)
                completion(event: event, error: nil)
                
            } else {
                let error = NSError(message: NSLocalizedString("Server sent empty response", comment: ""))
                completion(event: nil, error: error)
            }
            
        }, failure: { error in
            completion(event: nil, error: error)
        })
    }
    
    func checkEventsAvailability(completion: (available: Bool, error: NSError?) -> Void) {
        
        let query = FreeBusyQuery(calendarsIDs: [eventQuery.calendarID], eventEndDate: eventQuery.endDate)
        
        NetworkManager.sharedInstance.request(query, success: { response in
            
            if let response = response {
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                formatter.timeZone = NSTimeZone.localTimeZone()
                
                var busyTimeFrames: [TimeFrame]?
                let timeMin = formatter.dateFromString(response["timeMin"].string!)
                let timeMax = formatter.dateFromString(response["timeMax"].string!)
                
                for calendar in response["calendars"].dictionaryValue {
                    let calendarJSON = calendar.1.dictionaryValue
                    busyTimeFrames = TimeFrame.map(calendarJSON["busy"]?.arrayValue)
                }

                busyTimeFrames = self.excludeCurrentEditingEventFromBusyTimeFrames(busyTimeFrames)
                
                var error: NSError?
                let freeTimeRanges = self.fillRevertedBusyTimeFramesWithFreeTimeRanges(busyTimeFrames, startWithDate: timeMin, endWithDate: timeMax)
                
                let available = freeTimeRanges.filter {
                    let doesAnyOfAvailableFreeTimeRangeContainCurrentlyEditingEventNewTimeRange = self.eventQuery.startDate >= $0.min && self.eventQuery.endDate <= $0.max
                    return doesAnyOfAvailableFreeTimeRangeContainCurrentlyEditingEventNewTimeRange
                }.count > 0
                
                if !available {
                    error = NSError(message: NSLocalizedString("The room is busy in provided time range", comment: ""))
                }
                
                completion(available: available, error: error)
                return
            }
            
            let error = NSError(message: NSLocalizedString("Server respond with empty response", comment: ""))
            completion(available: false, error: error)
            
            }, failure: { error in
                completion(available: false, error: error)
        })
    }
    
    func excludeCurrentEditingEventFromBusyTimeFrames(busyTimeFrames: [TimeFrame]?) -> [TimeFrame]? {
        
        if busyTimeFrames == nil {
           return nil
        }
        
        var array: [TimeFrame] = []
        for busyTimeFrame in busyTimeFrames! {
            
            if currentEditingEventInitialStartDate >= busyTimeFrame.startDate && currentEditingEventInitialEndDate <= busyTimeFrame.endDate {
                
                let isInBusyTimeFrameAnyOtherEventBeforeCurrentlyEditingEvent = currentEditingEventInitialStartDate > busyTimeFrame.startDate
                // if yes then add busy time range
                if isInBusyTimeFrameAnyOtherEventBeforeCurrentlyEditingEvent {
                    let busyTimeFrameBeforeCyrrentlyEditingEvent = TimeFrame(startDate: busyTimeFrame.startDate, endDate: currentEditingEventInitialStartDate)
                    array.append(busyTimeFrameBeforeCyrrentlyEditingEvent)
                }
                
                let isInBusyTimeFrameAnyOtherEventAfterCurrentlyEditingEvent = currentEditingEventInitialEndDate < busyTimeFrame.endDate
                // if yes then add busy time range
                if isInBusyTimeFrameAnyOtherEventAfterCurrentlyEditingEvent {
                    let busyTimeFrameAfterCurrentlyEditingEvent = TimeFrame(startDate: currentEditingEventInitialEndDate, endDate: busyTimeFrame.endDate)
                    array.append(busyTimeFrameAfterCurrentlyEditingEvent)
                }
            } else {
                array.append(busyTimeFrame)
            }
        }
            
        return array
    }
    
    func fillRevertedBusyTimeFramesWithFreeTimeRanges(busyTimeFrames: [TimeFrame]?, startWithDate timeMin: NSDate?, endWithDate timeMax: NSDate?) -> [TimeRange] {
        
        var freeTimeRanges: [TimeRange] = []
        
        if let busyTimeFrames = busyTimeFrames {
            
            for index in 0...busyTimeFrames.count  {
                
                var min, max: NSDate!
                
                if index == 0 {
                    min = timeMin
                    max = busyTimeFrames[index].startDate
                    
                } else if index == busyTimeFrames.count {
                    min = busyTimeFrames[index - 1].endDate
                    max = timeMax
                    
                } else {
                    min = busyTimeFrames[index - 1].endDate
                    max = busyTimeFrames[index].startDate
                }
                
                if max.timeIntervalSinceDate(min) > 0 {
                    freeTimeRanges.append(TimeRange(min: min ,max: max))
                }
            }
        }
        
        return freeTimeRanges
    }
    
    func fixResponse(response: JSON) -> JSON {
        
        /* NOTICE:
        * When editing event Google Calendar doesn't return "self" in response (in resource)
        * because is waiting for resource acceptation.
        *
        * To avoid UI glitches, resource here is mocked
        * as that one which was send in request.
        */
        
        var mockedAttendees: [[String : String]] = []
        
        for attendee in response["attendees"].arrayValue {
            
            var mockedAttendee = [
                "email" : attendee["email"].object as! String,
                "displayName" : attendee["displayName"].object as! String,
                "responseStatus" : attendee["responseStatus"].object as! String
            ]
            
            if let resource = attendee["resource"].object as? Bool {
                mockedAttendee["resource"] = resource ? "true" : "false"
            }
            if let isSelf = attendee["resource"].object as? Bool {
                mockedAttendee["self"] = isSelf ? "true" : "false"
            } else {
                mockedAttendee["self"] = "false"
            }
            
            mockedAttendees.append(mockedAttendee)
        }
        return JSON(mockedAttendees)
    }
}
