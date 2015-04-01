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

    required init(coder aDecoder: NSCoder) {
        self.duration = aDecoder.decodeDoubleForKey("duration")
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(self.duration, forKey: "duration")
    }
}


extension TimeFrame {
    
    convenience init(freeEvent: FreeEvent) {
        let today = NSDate()
        
        if let start = freeEvent.start {
            if let end = freeEvent.end {
                self.init(startDate: start, endDate: end, availability: .Available)
            } else {
                self.init(startDate: today, endDate: today, availability: .Available)
            }
        } else {
            self.init(startDate: today, endDate: today, availability: .Available)
        }
    }
    
}