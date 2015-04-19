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
    
    convenience init(_ calendarTimeFrame: CalendarTimeFrame) {
        let URLExtension = "/calendars/" + calendarTimeFrame.1 + "/events"
        self.init(.POST, URLExtension: URLExtension, parameters: nil, encoding: .JSON)
        
        startDate = calendarTimeFrame.0?.startDate
        endDate = calendarTimeFrame.0?.endDate
    }
    
    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .URL) {
        super.init(HTTPMethod, URLExtension: URLExtension, parameters: parameters, encoding: encoding)
        timeZone = NSTimeZone.localTimeZone().name
    }
    
    // MARK: Parameters
    
    var summary: String {
        get { return self[SummaryKey] as? String ?? "" }
        set { self[SummaryKey] = newValue }
    }
    
    var startDate: NSDate? {
        get { return dateForKey(StartKey) }
        set { setDate(newValue, forKey: StartKey) }
    }
    
    var endDate: NSDate? {
        get { return dateForKey(EndKey) }
        set { setDate(newValue, forKey: EndKey) }
    }
    
    var timeZone: String {
        get { return timeZoneForDateKey(StartKey) }
        set {
            setTimeZone(newValue, forDateKey: StartKey)
            setTimeZone(newValue, forDateKey: EndKey)
        }
    }
    
    // MARK: Private keys
    
    private let TimeZoneKey = "timeZone"
    private let SummaryKey = "summary"
    private let DateKey = "date"
    private let DateTimeKey = "dateTime"
    private let StartKey = "start"
    private let EndKey = "end"
    
    // MARK: Private functions
    
    private func dateForKey(key: String) -> NSDate? {
        if let dateDict = self[key] as? [String: String], dateString = dateDict[DateTimeKey] {
            return formatter.dateFromString(dateString)
        }
        return nil
    }
    
    private func setDate(date: NSDate?, forKey key: String) {
        if let _date = date {
            var dateDict = [DateTimeKey: formatter.stringFromDate(_date)]
            let timeZone = self.timeZone
            
            if !timeZone.isEmpty {
                dateDict[TimeZoneKey] = NSTimeZone.localTimeZone().name
            }
            self[key] = dateDict
        } else {
            self[key] = nil
        }
    }
    
    private func setTimeZone(timeZone: String, forDateKey key: String) {
        if var dateDict = self[key] as? [String: AnyObject] {
            dateDict[TimeZoneKey] = timeZone
        }
    }
    
    private func timeZoneForDateKey(key: String) -> String {
        if var dateDict = self[key] as? [String: AnyObject], timeZone = dateDict[TimeZoneKey] as? String {
            return timeZone
        }
        return NSTimeZone.localTimeZone().name
    }
}
