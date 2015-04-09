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
    
    convenience init(calendarID: String) {
        let URLExtension = "/calendars/" + calendarID + "/events"
        self.init(.GET, URLExtension: URLExtension)
        _calendarID = calendarID
    }
    

    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .URL) {
        super.init(HTTPMethod, URLExtension: URLExtension)
    }
    
    // MARK: Copy
    
    func copy(#calendarID: String) -> EventsQuery {
        var query = EventsQuery(calendarID: calendarID)
        query.maxResults = self.maxResults
        query.timeMax = self.timeMax?.copy() as? NSDate
        query.timeMin = self.timeMin?.copy() as? NSDate
        query.orderBy = self.orderBy
        query.singleEvents = self.singleEvents
        return query
    }

    
    // MARK: Query parameters
    
    var calendarID: String { get { return _calendarID } }
    
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
    
    class func queries(calendars: [String]) -> [EventsQuery] {
        var queries: [EventsQuery] = []
        
        for calendarID in calendars {
            queries.append(EventsQuery(calendarID: calendarID))
        }
        
        return queries
    }
}
