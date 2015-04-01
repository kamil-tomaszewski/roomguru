//
//  CalendarEntry.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 01/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class CalendarEntry: NSObject, NSSecureCoding {
    
    let calendarID: String = ""
    let event: Event = Event()
    
    init(calendarID: String, event: Event) {
        self.calendarID = calendarID
        self.event = event
        super.init()
    }
    
    // MARK: NSSecureCoding
    
    required init(coder aDecoder: NSCoder) {
        if let calendarID = aDecoder.decodeObjectForKey("calendarID") as? String {
            self.calendarID = calendarID
        }
        
        if let event = aDecoder.decodeObjectOfClass(Event.self, forKey: "event") as? Event {
            self.event = event
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.calendarID, forKey: "calendarID")
        aCoder.encodeObject(self.event, forKey: "event")
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
}
