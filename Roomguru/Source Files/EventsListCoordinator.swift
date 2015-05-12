//
//  EventsListCoordinator.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum ResponseStatus {
    case Success, Empty, Failed
}

class EventsListCoordinator {
    
    var viewModel: EventsListViewModel<CalendarEntry>?
    
    var date: NSDate
    var eventsProvider: EventsProvider
    
    init(date: NSDate, calendarIDs: [String]) {
        self.date = date
        self.eventsProvider = EventsProvider(calendarIDs: calendarIDs, timeRange: date.dayTimeRange())
    }
    
    func loadDataWithCompletion(completion: (status: ResponseStatus, message: String, icon: FontAwesome?) -> Void) {
        
        eventsProvider.activeCalendarEntriesWithCompletion { [weak self] (calendarEntries, error) in
            
            self?.viewModel = EventsListViewModel(calendarEntries)
            
            if let error = error {
                let message = NSLocalizedString("Sorry, something went wrong.\n\nTo reload, tap again on the navigation bar.", comment: "")
                completion(status: .Failed, message: message, icon: .MehO)
            } else if calendarEntries.isEmpty {
                completion(status: .Empty, message: NSLocalizedString("Weekend day.\nGo away and relax!", comment: ""), icon: .CalendarO)
            } else {
                completion(status: .Success, message: "", icon: nil)
            }
        }
    }
    
    func revocable() -> Bool {
        return false
    }
}

