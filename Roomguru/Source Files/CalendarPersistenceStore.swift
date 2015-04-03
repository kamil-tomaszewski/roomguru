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
    
    class func saveCalendars(calendars: [Calendar]) {
        let dataRepresentation = NSKeyedArchiver.archivedDataWithRootObject(calendars)
        Defaults["CalendarsKey"] = dataRepresentation
        Defaults.synchronize()
    }
    
    class func fetch() -> [Calendar]? {
        if let data = Defaults["CalendarsKey"].data {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Calendar]
        }
        return nil
    }
}
