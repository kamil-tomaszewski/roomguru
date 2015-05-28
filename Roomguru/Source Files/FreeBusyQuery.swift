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
    
    var startDate: NSDate? {
        if let dateString = self[TimeMinKey] as? String {
            return formatter.dateFromString(dateString)
        }
        return nil
    }
    var endDate: NSDate? {
        if let dateString = self[TimeMaxKey] as? String {
            return formatter.dateFromString(dateString)
        }
        return nil
    }
        
    convenience init(calendarsIDs: [String], searchTimeRange: TimeRange) {
        self.init(.POST, URLExtension: "/freeBusy")
        self[ItemsKey] = calendarsIDs.map { ["id": $0] }
        self[TimeMinKey] = formatter.stringFromDate(searchTimeRange.min)
        self[TimeMaxKey] = formatter.stringFromDate(searchTimeRange.max)
    }
    
    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .JSON) {
        super.init(HTTPMethod, URLExtension: URLExtension, parameters: parameters, encoding: encoding)
        self[TimeZoneKey] = "Europe/Warsaw"
    }
    
    
    // MARK: Private
    
    private let TimeMaxKey = "timeMax"
    private let TimeMinKey = "timeMin"
    private let TimeZoneKey = "timeZone"
    private let ItemsKey = "items"
}
