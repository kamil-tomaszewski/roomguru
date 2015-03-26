//
//  AvailabilityCalendar.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DateKit

typealias CalendarTimeFrame = (TimeFrame?, String)

class AvailabilityCalendar: NSObject {
    
    let calendarID: String
    private var timeFrames: [TimeFrame]
    
    init(calendarID: String, timeFrames: [TimeFrame]) {
        self.calendarID = calendarID
        self.timeFrames = timeFrames
        self.timeFrames.sort{ $0.startDate <= $1.startDate }
        super.init()
    }
    
}


extension AvailabilityCalendar {
    
    func closestFreeTimeFrame() -> CalendarTimeFrame? {
        
        if let timeFree = checkEndOfADay() {
            return timeFree
        }
        
        if let timeFree = checkFreeBeforeAnyBusy() {
            return timeFree
        }
        
        for (index, frame) in enumerate(timeFrames) {
            
            let nextIndex = index + 1
            let timeFramesCount = timeFrames.count
            let startDate = frame.endDate

            if nextIndex < timeFramesCount {

                let nextFrame = timeFrames[nextIndex]
                
                if startDate.day == nextFrame.endDate.day {
                    
                    let minutes = frame.endDate.timeIntervalSinceDate(nextFrame.startDate)/60
                    
                    if minutes >= 30 {
                        let endDate = startDate.minutes + 30
                        let timeFrame = TimeFrame(startDate: startDate, endDate: endDate, availability: .Available)
                        return (timeFrame, calendarID)
                    }
                    
                }
                
            } else {
                let endDate = frame.endDate.tomorrow.midnight.seconds - 1
                let timeFrame = TimeFrame(startDate: startDate, endDate: endDate, availability: .Available)
                return (timeFrame, calendarID)
            }
            
        }
        
        return nil
        
    }
    
    private func checkEndOfADay() -> CalendarTimeFrame? {
        
        let today = NSDate()
        let firstFrame = timeFrames[0]
        
        if firstFrame.startDate.day > today.day {
            let endDate = today.tomorrow.midnight.seconds - 1
            let timeFrame = TimeFrame(startDate: today, endDate: endDate, availability: .Available)
            return (timeFrame, calendarID)
        }
        
        return nil;
        
    }
    
    private func checkFreeBeforeAnyBusy() -> CalendarTimeFrame? {
        
        let today = NSDate()
        let firstFrame = timeFrames[0]
        let firstFrameStartHour = firstFrame.startDate.hour        
        let minutes = firstFrame.startDate.timeIntervalSinceDate(today)/60
        
        if firstFrameStartHour >= today.hour && minutes >= 30 {
            let startDate = firstFrame.startDate.minutes - 30
            let endDate = firstFrame.startDate
            let timeFrame = TimeFrame(startDate: startDate, endDate: endDate, availability: .Available)
            return (timeFrame, calendarID)
        }
        
        return nil

    }
    
}
