//
//  CalendarPickerViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 02/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CalendarPickerViewModel: NSObject {

    let calendars: [Calendar]
    
    init(calendars: [Calendar]) {
        self.calendars = calendars
        super.init()
    }
    
    // MARK: Public
    
    func numberOfCalendars() -> Int {
        return calendars.count ?? 0
    }
    
    subscript(index: Int) -> Calendar {
        return calendars[index]
    }
}
