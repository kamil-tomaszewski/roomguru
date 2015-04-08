//
//  CalendarPersistenceStore.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class CalendarPersistenceStore: NSObject {
    
    class var sharedStore: CalendarPersistenceStore {
        struct Static {
            static let instance: CalendarPersistenceStore = CalendarPersistenceStore()
        }
        return Static.instance
    }
    
    var calendars: [Calendar] = []
    
    override init() {
        super.init()
        calendars = fetch() ?? []
    }
    
    subscript(index: Int) -> (name: String?, id: String?) {
        return (calendars[index].summary, calendars[index].identifier)
    }
    
    func names() -> [String] {
        var array: [String] = []
        for calendar: Calendar in calendars {
            if let _summary = calendar.summary {
                array += [_summary]
            }
        }
        return array
    }
    
    func matchingCalendar(calendar: Calendar) -> Calendar? {
        return calendars.filter{ $0 == calendar }.first
    }
    
    // MARK: Saving and Reading
    
    func saveCalendars(calendars: [Calendar]) {
        let dataRepresentation = NSKeyedArchiver.archivedDataWithRootObject(calendars)
        Defaults["CalendarsKey"] = dataRepresentation
        Defaults.synchronize()
        
        self.calendars = calendars
    }
    
    func fetch() -> [Calendar]? {
        if let data = Defaults["CalendarsKey"].data {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Calendar]
        }
        return nil
    }
}
