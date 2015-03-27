//
//  BookingQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire

class BookingQuery: Query {
    
    // MARK: Initializers
    
    convenience init(calendarTimeFrame: CalendarTimeFrame) {
        let URLExtension = "/calendars/" + calendarTimeFrame.1 + "/events"
        self.init(.GET, URLExtension: URLExtension)
        
        self.startDate = calendarTimeFrame.0?.startDate
        self.endDate = calendarTimeFrame.0?.endDate
    }
    
    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .URL) {
        super.init(HTTPMethod, URLExtension: URLExtension)
    }
    
    var summary: String {
        get { return self[SummaryKey] as String }
        set { self[SummaryKey] = newValue }
    }
    
    var startDate: NSDate? {
        get { return getDateForKey(StartKey) }
        set { setDate(newValue, forKey: StartKey) }
    }
    
    var endDate: NSDate? {
        get { return getDateForKey(EndKey) }
        set { setDate(newValue, forKey: EndKey) }
    }

    // MARK: Private
    
    private let SummaryKey = "summary"
    private let DateTimeKey = "dateTime"
    private let StartKey = "start"
    private let EndKey = "end"
    
    private func getDateForKey(key: String) -> NSDate? {
        if let dateString: String = (self[key] as Dictionary)[DateTimeKey] {
            return formatter.dateFromString(dateString)
        }
        return nil
    }
    
    private func setDate(date: NSDate?, forKey key: String) {
        if let newStartDate = date {
            self[key] = [DateTimeKey: formatter.stringFromDate(newStartDate)]
        } else {
            self[key] = nil
        }
    }
    
}
