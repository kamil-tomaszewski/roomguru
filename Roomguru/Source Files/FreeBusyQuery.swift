//
//  FreeBusyQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 25/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire
import DateKit

class FreeBusyQuery: Query {
    
    convenience init(calendarsIDs: [String]) {
        self.init(.POST, URLExtension: "/freeBusy", parameters: nil)
        self[ItemsKey] = calendarsIDs.map { ["id": $0] }
    }
    
    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters?) {
        super.init(HTTPMethod, URLExtension: URLExtension, parameters: parameters)
        
        let today = NSDate()
        self[TimeMinKey] = formatter.stringFromDate(today)
        self[TimeMaxKey] = formatter.stringFromDate(today.days + 2)
        self[TimeZoneKey] = "Europe/Warsaw"
    }
    
    
    // MARK: Private
    
    private let TimeMaxKey = "timeMax"
    private let TimeMinKey = "timeMin"
    private let TimeZoneKey = "timeZone"
    private let ItemsKey = "items"
}
