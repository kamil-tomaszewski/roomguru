//
//  CalendarListViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class CalendarListViewModel<T: CalendarEntry>: ListViewModel<CalendarEntry> {
    
    init(_ items: [T], sortingKey: String) {
        super.init(items, sortingKey: sortingKey)
    }
}
