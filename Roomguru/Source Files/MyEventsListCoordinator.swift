//
//  MyEventsListCoordinator.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 12/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class MyEventsListCoordinator: EventsListCoordinator {
    
    override func loadDataWithCompletion(completion: (status: ResponseStatus, message: String, icon: FontAwesome?) -> Void)  {

        eventsProvider.userActiveCalendarEntriesWithCompletion { [weak self] (calendarEntries, error) in
                
            self?.viewModel = EventsListViewModel(calendarEntries)
            
            if let error = error {
                let message = NSLocalizedString("Sorry, something went wrong.\n\nTo reload, tap again on the navigation bar.", comment: "")
                completion(status: .Failed, message: message, icon: .MehO)
            } else if calendarEntries.isEmpty {
                completion(status: .Empty, message: NSLocalizedString("You haven't got any meetings this day.\n\nFinally peace and quiet.", comment: ""), icon: .SmileO)
            } else {
                completion(status: .Success, message: "", icon: nil)
            }
        }
    }
    
    override func revocable() -> Bool {
        return true
    }
}
