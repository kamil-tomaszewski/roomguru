//
//  CalendarEntry.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 01/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class CalendarEntry: NSObject, NSSecureCoding {
    
    let calendarID: String?
    let event: Event?
    
    init(calendarID: String, event: Event) {
        self.calendarID = calendarID
        self.event = event
        super.init()
    }
    
    // MARK: NSSecureCoding
    
    required init(coder aDecoder: NSCoder) {
        self.calendarID = aDecoder.decodeObjectForKey("calendarID") as? String
        self.event = aDecoder.decodeObjectOfClass(Event.self, forKey: "event") as? Event
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.calendarID, forKey: "calendarID")
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
    
}
