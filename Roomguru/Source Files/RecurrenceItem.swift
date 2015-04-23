//
//  RecurrenceItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 22/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class RecurrenceItem: PickerItem {
    
    enum Recurrence: String {
        case None = ""
        case Daily = "DAILY"
        case Weekly = "WEEKLY"
        case Monthly = "MONTHLY"
        case Yearly = "YEARLY"
    }
    
    var recurrence: Recurrence
    var value: String {
        get {
            if recurrence == .None {
                return recurrence.rawValue
            }
            return "RRULE:FREQ=" + recurrence.rawValue + ";BYDAY=MO,TU,WE,TH,FR"
        }
    }
    
    init(title: String, recurrence: Recurrence, selected: Bool = false) {
        self.recurrence = recurrence
        super.init(title: title, selected: selected)
    }
}
