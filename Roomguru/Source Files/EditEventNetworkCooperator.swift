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
    
    init(query: EventQuery) {
        eventQuery = query
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
        
        let query = FreeBusyQuery(calendarsIDs: [eventQuery.calendarID])
        
        NetworkManager.sharedInstance.request(query, success: { response in
            
            println(self.eventQuery.startDate)
            println(self.eventQuery.endDate)
            
            if let response = response {
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                formatter.timeZone = NSTimeZone.localTimeZone()
                
                var timeFrames: [TimeFrame]?
                let timeMin = formatter.dateFromString(response["timeMin"].string!)
                let timeMax = formatter.dateFromString(response["timeMax"].string!)
                
                for calendar in response["calendars"].dictionaryValue {
                    let calendarJSON = calendar.1.dictionaryValue
                    timeFrames = TimeFrame.map(calendarJSON["busy"]?.arrayValue)
                }
                
                // add current editing event time range, because it should be editable:
                var freeTimeRanges: [TimeRange] = [(min: self.eventQuery.startDate ,max: self.eventQuery.endDate)]
                
                if let timeFrames = timeFrames {
                    
                    for index in 0...timeFrames.count  {
                        
                        var min, max: NSDate!
                        
                        if index == 0 {
                            min = timeMin
                            max = timeFrames[index].startDate
                            
                        } else if index == timeFrames.count {
                            min = timeFrames[index - 1].endDate
                            max = timeMax
                            
                        } else {
                            min = timeFrames[index - 1].endDate
                            max = timeFrames[index].startDate
                        }
                        
                        if max.timeIntervalSinceDate(min) > 0 {
                            freeTimeRanges.append(TimeRange(min: min ,max: max))
                        }
                    }
                }
                
                var error: NSError?
                let filteredTimesRanges = freeTimeRanges.filter { self.eventQuery.startDate >= $0.min && self.eventQuery.endDate <= $0.max }
                
                if filteredTimesRanges.isEmpty {
                    error = NSError(message: NSLocalizedString("The room is busy in provided time range", comment: ""))
                }
                completion(available: error == nil, error: error)
                return
            }
            
            let error = NSError(message: NSLocalizedString("Server respond with empty response", comment: ""))
            completion(available: false, error: error)
            
            }, failure: { error in
                completion(available: false, error: error)
        })
    }
    
    private func fixResponse(response: JSON) -> JSON {
        
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
