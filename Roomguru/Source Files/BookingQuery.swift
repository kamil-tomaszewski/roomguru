//
//  BookingQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire
import DateKit

class BookingQuery: Query {
    
    private static var URLExtension = "/calendars/primary/events"
    
    private var attendees: [[String: String]] = []
    private let dateFormatter = NSDateFormatter()
    
    // MARK: Initializers
    
    convenience init(calendarEntry: CalendarEntry) {
        let URLExtension = BookingQuery.URLExtension + "/" + calendarEntry.event.identifier!
        self.init(.PUT, URLExtension: URLExtension)
        
        populateQueryWithCalendarEntry(calendarEntry)
        
        addAttendees(calendarEntry.event.attendees.filter { $0.email != nil }.map { $0.email! })
        updateCalendarAsAttendee(nil, new: calendarID)
    }
    
    convenience init(quickCalendarEntry calendarEntry: CalendarEntry) {
        self.init(.POST)
        
        populateQueryWithCalendarEntry(calendarEntry)
        updateCalendarAsAttendee(nil, new: calendarID)
    }
    
    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String = BookingQuery.URLExtension, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .JSON) {

        calendarID = ""
        
        super.init(HTTPMethod, URLExtension: URLExtension, parameters: parameters, encoding: encoding)
        
        timeZone = NSTimeZone.localTimeZone().name
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        addLoggedUserAsAttendee()
    }
    
    // MARK: Parameters
    
    var calendarID: String {
        willSet { updateCalendarAsAttendee(calendarID, new: newValue) }
    }
    
    var allDay: Bool {
        get { return isAllDay() }
        set {
            if newValue {
                setAllDay(startDate ?? NSDate())
            } else {
                cancelAllDay()
            }
        }
    }
    
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
    
    var status: EventStatus {
        get {
            if let status = self[StatusKey] as? String {
                return EventStatus(rawValue: status) ?? .Confirmed
            }
            return .Confirmed
        }
        set { self[StatusKey] = newValue.rawValue }
    }
    
    // MARK: Attendees
    
    func addAttendees(emails: [String]) {
        for email in emails {
            addAttendee(email)
        }
    }
    
    func addAttendee(email: String) {
        addAttendeesByDictionary([EmailKey : email])
    }
    
    func setAttendees(emails: [String]) {
        attendees = []
        for email in emails {
            attendees.append([EmailKey : email])
        }
        self[AttendeesKey] = attendees
    }
    
    func removeAttendee(email: String) {
        attendees = attendees.filter { $0[self.EmailKey] != email }
        self[AttendeesKey] = attendees
    }
    
    // MARK: Private keys

    private let AttendeesKey = "attendees"
    private let DateKey = "date"
    private let DateTimeKey = "dateTime"
    private let EmailKey = "email"
    private let EndKey = "end"
    private let ResponseStatusKey = "responseStatus"
    private let StartKey = "start"
    private let StatusKey = "status"
    private let SummaryKey = "summary"
    private let TimeZoneKey = "timeZone"

    // MARK: Private functions
    
    private func dateForKey(key: String) -> NSDate? {
        if let dateDict = self[key] as? [String: String], dateString = dateDict[DateTimeKey] {
            return formatter.dateFromString(dateString)
        }
        return nil
    }
    
    private func setDate(date: NSDate?, forKey key: String) {
        if let date = date {
            var dateDict = [DateTimeKey: formatter.stringFromDate(date)]
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
    
    private func addAttendeesByDictionary(attendeeDict: [String: String]) {
        attendees.append(attendeeDict)
        self[AttendeesKey] = attendees
    }
    
    private func addLoggedUserAsAttendee() {
        if let user = UserPersistenceStore.sharedStore.user {
            addAttendeesByDictionary([
                EmailKey: user.email,
                ResponseStatusKey: "accepted"
            ])
        }
    }
    
    private func updateCalendarAsAttendee(old: String?, new: String) {
        if let old = old { removeAttendee(old) }
        addAttendeesByDictionary([
            EmailKey: new,
            ResponseStatusKey: "accepted"
        ])
    }
    
    private func isAllDay() -> Bool {
        var result = false
        
        if var startDict = self[StartKey] as? [String: AnyObject] {
            result = startDict[DateKey] != nil && startDict[DateTimeKey] == nil
        }
        
        if var endDict = self[EndKey] as? [String: AnyObject] where result {
            result = endDict[DateKey] != nil && endDict[DateTimeKey] == nil
        }
        
        return result
    }
    
    private func setAllDay(date: NSDate) {
        let start = date.midnight
        let end = date.tomorrow.midnight.seconds - 1
        
        let startString = dateFormatter.stringFromDate(start)
        let endString = dateFormatter.stringFromDate(end)
        
        if var startDict = self[StartKey] as? [String: AnyObject] {
            startDict[DateKey] = startString
            startDict.removeValueForKey(DateTimeKey)
            self[StartKey] = startDict
        } else {
            self[StartKey] = [
                DateKey: startString,
                TimeZoneKey: timeZone
            ]
        }
        
        if var endDict = self[EndKey] as? [String: AnyObject] {
            endDict[DateKey] = endString
            endDict.removeValueForKey(DateTimeKey)
            self[EndKey] = endDict
        } else {
            self[EndKey] = [
                DateKey: endString,
                TimeZoneKey: timeZone
            ]
        }
    }
    
    private func cancelAllDay() {
        if var startDict = self[StartKey] as? [String: AnyObject] {
            startDict.removeValueForKey(DateKey)
        }
        
        if var endDict = self[EndKey] as? [String: AnyObject] {
            endDict.removeValueForKey(DateKey)
        }
    }
    
    private func populateQueryWithCalendarEntry(calendarEntry: CalendarEntry) {
        
        calendarID = calendarEntry.calendarID
        summary = calendarEntry.event.summary ?? ""
        startDate = calendarEntry.event.start
        endDate = calendarEntry.event.end
    }
}
