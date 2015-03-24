//
//  BookingManager.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class BookingManager: NSObject {
    
    // this method needs further implementation and will be refactored
    func bookTheClosestAvailableRoom(success: ResponseBlock, failure: ErrorBlock) {
        
        let allRooms = [Room.Aqua, Room.Cold, Room.Middle]
        
        NetworkManager.sharedInstance.freebusyList(allRooms, success: { (response: JSON?) -> () in
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ZZZ"
            
            let calendarsFreeBusyDictionary: [String : JSON]? = response?["calendars"].dictionaryValue

            if let _calendarsFreeBusyDictionary = calendarsFreeBusyDictionary {
                for calendar in _calendarsFreeBusyDictionary {
                    
                    let dict: [String : JSON] = calendar.1.dictionaryValue
                    let array: [JSON] = dict["busy"]!.arrayValue
                    
                    var timeFrames = [TimeFrame]()
                    
                    for item in array {
                        let startString: String = item["start"].stringValue
                        let endString: String = item["end"].stringValue
                        let startDate: NSDate! = formatter.dateFromString(startString)
                        let endDate: NSDate! = formatter.dateFromString(endString)
                        
                        let timeFrame: TimeFrame = TimeFrame(startDate: startDate, endDate: endDate, availability: TimeFrameAvailability.NotAvailable)
                        timeFrames.append(timeFrame)
                    }
                    
                    let formatterWithTimeZone = NSDateFormatter()
                    formatterWithTimeZone.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
                    
                    let timeMinString: String = response!["timeMin"].stringValue
                    let timeMin: NSDate! = formatterWithTimeZone.dateFromString(timeMinString)
                    let timeMaxString: String = response!["timeMax"].stringValue
                    let timeMax: NSDate! = formatterWithTimeZone.dateFromString(timeMaxString)
                    
                    let availabilityCalendar = AvailabilityCalendar(calendarID: calendar.0, startDate: timeMin, endDate: timeMax, timeFrames: timeFrames)
                    let closestFreeTimeFrame: TimeFrame? = availabilityCalendar.closestFreeTimeFrame()
                    println(availabilityCalendar)
                }
            }
            
            
        }, failure: { (error: NSError) -> () in
            println(error)
        })
    }
}
