//
//  EventDetailsViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class EventDetailsViewModel: NSObject {
    
    private let event: Event?
    
    init(event: Event?) {
        self.event = event
        super.init()
    }
    
    func title() -> String? {
        return self.event?.summary
    }

}
