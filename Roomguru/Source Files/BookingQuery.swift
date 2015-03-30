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
        
        self.startDate = calendarTimeFrame.0?.startDate
        self.endDate = calendarTimeFrame.0?.endDate
        self.timeZone = NSTimeZone.localTimeZone().name
    }
    
    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .URL) {
        super.init(HTTPMethod, URLExtension: URLExtension, parameters: parameters, encoding: encoding)
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

    var timeZone: String {
        get { return _timeZone }
        set {
            _timeZone = newValue
            setTimeZone(_timeZone, forDateKey: StartKey)
            setTimeZone(_timeZone, forDateKey: EndKey)
        }
    }
    
    // MARK: Private
    
    private var _timeZone: String = ""
    
    private let TimeZoneKey = "timeZone"
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
        if let _date = date {
            var dateDict = [DateTimeKey: formatter.stringFromDate(_date)]
            
            if !_timeZone.isEmpty {
                dateDict[TimeZoneKey] = _timeZone
            }
            self[key] = dateDict
        } else {
            self[key] = nil
        }
    }
    
    private func setTimeZone(timeZone: String, forDateKey key: String) {
        if var dateDict: [String: AnyObject] = self[key] as? [String: AnyObject] {
            dateDict[TimeZoneKey] = timeZone
        }
    }
}
