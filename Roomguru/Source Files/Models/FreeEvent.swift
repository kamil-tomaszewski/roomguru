//
//  FreeEvent.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 24/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

class FreeEvent: Event {
    
    init(startDate: NSDate, endDate: NSDate) {
        
        super.init()
        
        start = startDate
        end = endDate
    }

    required init(json: JSON) {
        super.init(json: json)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
