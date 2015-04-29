//
//  WeekCarouselViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DateKit

class WeekCarouselViewModel {
    
    let numberOfDaysInWeek = 7
    let calendar = NSCalendar.currentCalendar()
    let dateFormatter = NSDateFormatter()
    
    private(set) var days: [NSDate] = []
    
    init() {
        calendar.firstWeekday = 2 //Monday
        calendar.timeZone = NSTimeZone.localTimeZone()
        calendar.locale = NSLocale.currentLocale()
        
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "d"
        
        let monday = calendar.mondayDateInWeekDate(NSDate())
        var startDate = monday.days - 14
        let endDate = monday.days + 13
        
        while startDate.isEarlierThan(endDate) {
            
            days += [startDate]
            startDate = startDate.days + 1
        }        
    }
    
    subscript(index: Int) -> (date: NSDate, day: String, isToday: Bool) {
        return (days[index], dateFormatter.stringFromDate(days[index]), days[index].isToday())
    }
    
    func dateStringWithIndex(index: Int) -> String {
        dateFormatter.dateFormat = "EEEE d LLLL yyyy"
        let string = dateFormatter.stringFromDate(days[index])
        dateFormatter.dateFormat = "d"
        return string
    }
    
    func indexFromDate(date: NSDate) -> Int? {
        for (index, element) in enumerate(days) {
            if element.isSameDayAs(date) {
                return index
            }
        }
        return nil
    }
}
