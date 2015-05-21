//
//  EventsQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire


class EventsQuery: PageableQuery {
    
    // MARK: Initializers
    
    convenience init(calendarID: String, timeRange: TimeRange) {
        let URLExtension = "/calendars/" + calendarID + "/events"
        self.init(.GET, URLExtension: URLExtension)
        _calendarID = calendarID
        
        maxResults = 100
        singleEvents = true
        orderBy = "startTime"
        timeMin = timeRange.min
        timeMax = timeRange.max
    }

    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .URL) {
        super.init(HTTPMethod, URLExtension: URLExtension)
    }
    
    // MARK: Query parameters
    
    var calendarID: String { return _calendarID }
    
    var maxResults: Int? {
        get { return self[MaxResultsKey] as! Int? }
        set { self[MaxResultsKey] = newValue }
    }
    
    var timeMax: NSDate? {
        get { return formatter.dateFromString(self[TimeMaxKey] as! String) }
        set {
            if let newTimeMax: NSDate = newValue {
                self[TimeMaxKey] = formatter.stringFromDate(newTimeMax)
            } else {
                self[TimeMaxKey] = nil
            }
        }
    }
    
    var timeMin: NSDate? {
        get { return formatter.dateFromString(self[TimeMinKey] as! String) }
        set {
            if let newTimeMin: NSDate = newValue {
                self[TimeMinKey] = formatter.stringFromDate(newTimeMin)
            } else {
                self[TimeMinKey] = nil
            }
        }
    }
    
    var orderBy: String? {
        get { return self[OrderByKey] as! String? }
        set { self[OrderByKey] = newValue }
    }
    
    var singleEvents: Bool? {
        get {
            let singleEve = self[SingleEventsKey] as! String
            return (singleEve == "true") as Bool?
        }
        set {
            self[SingleEventsKey] = (newValue != nil) ? "true" : nil
        }
    }
    
    
    // MARK: Private
    
    private var _calendarID: String = ""
    
    private let MaxResultsKey = "maxResults"
    private let TimeMaxKey = "timeMax"
    private let TimeMinKey = "timeMin"
    private let OrderByKey = "orderBy"
    private let SingleEventsKey = "singleEvents"
    
}


extension EventsQuery {
    
    class func queriesForCalendarIdentifiers(calendars: [String], withTimeRange timeRange: TimeRange) -> [EventsQuery] {
        var queries: [EventsQuery] = []
        
        for calendarID in calendars {
            queries.append(EventsQuery(calendarID: calendarID, timeRange: timeRange))
        }
        
        return queries
    }
}
