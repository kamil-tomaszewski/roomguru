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
    
    let calendar = NSCalendar.currentCalendar()
    let dateFormatter = NSDateFormatter()
    
    private(set) var days: [(date: NSDate, isToday: Bool)] = []
    
    init() {
        calendar.firstWeekday = 1
        calendar.timeZone = NSTimeZone.localTimeZone()
        calendar.locale = NSLocale.currentLocale()
        
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "d"
        
        let today = NSDate()
        var startDate = today.days - 14
        var endDate = today.days + 14
        
        while startDate.compare(endDate) != .OrderedDescending {
            
            let isToday = startDate.days == today.days
            days += [(date: startDate, isToday: isToday)]
            startDate = startDate.days + 1
        }        
    }
    
    subscript(index: Int) -> (date: NSDate, day: String, isToday: Bool) {
        return (days[index].date, dateFormatter.stringFromDate(days[index].date), days[index].isToday)
    }
    
}
