//
//  EventQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 14/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire
import DateKit

enum EventStatus: String {
    case Confirmed = "confirmed"
    case Tentative = "tentative"
    case Cancelled = "cancelled"
}

class EventQuery: BookingQuery {
    
    // MARK: Initializers
    
    convenience init() {
        self.init(.POST)
    }
    
    convenience init(calendarEntry: CalendarEntry) {
        self.init(.PUT)
        
        calendarID = calendarEntry.calendarID
        
        let event = calendarEntry.event
        
        summary = event.summary ?? ""
        startDate = event.start
        endDate = event.end
        
        let emails = event.attendees?.filter { $0.email != nil }.map { $0.email! }
        if var emails = emails {
            addAttendees(emails)
        }
    }

    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String = "/calendars/primary/events", parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .JSON) {
        super.init(HTTPMethod, URLExtension: URLExtension, parameters: nil, encoding: encoding)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        status = .Confirmed

        addLoggedUserAsAttendee()
    }
    
    // MARK: Parameters
    
    var calendarID: String? {
        willSet {
            if let calendarID = calendarID {
                removeAttendee(calendarID)
            }
            if let calendarID = newValue {
                addAttendeesByDictionary([
                    EmailKey: calendarID,
                    ResponseStatusKey: "accepted"
                ])
            }
        }
    }
    
    var eventDescription: String? {
        get { return self[DescriptionKey] as? String }
        set { self[DescriptionKey] = newValue }
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
    
    var recurrence: String {
        get { return (self[RecurrenceKey] as! [String]).first ?? "" }
        set { self[RecurrenceKey] = [newValue] }
    }
    
    func setAttendees(emails: [String]) {
        _attendees = []
        for email in emails {
            _attendees.append([EmailKey : email])
        }
        self[AttendeesKey] = _attendees
    }
    
    func addAttendees(emails: [String]) {
        for email in emails {
            addAttendee(email)
        }
    }
    
    func addAttendee(email: String) {
        addAttendeesByDictionary([EmailKey : email])
    }
    
    func removeAttendee(email: String) {
        removeOccurencesOfElement(_attendees, [EmailKey: email])
        self[AttendeesKey] = _attendees
    }
    
    override var HTTPMethod: Alamofire.Method {
        get { return _HTTPMethod }
    }

    // MARK: Keys
    
    private let StartKey = "start"
    private let EndKey = "end"
    private let DateKey = "date"
    private let DateTimeKey = "dateTime"
    private let AttendeesKey = "attendees"
    private let DescriptionKey = "description"
    private let StatusKey = "status"
    private let EmailKey = "email"
    private let ResponseStatusKey = "responseStatus"
    private let TimeZoneKey = "timeZone"
    private let RecurrenceKey = "recurrence"
    
    // MARK: Private members
    
    private var dateFormatter = NSDateFormatter()
    
    private var _HTTPMethod = Alamofire.Method.POST
    private var _attendees: [[String: String]] = []
    
    // MARK: Private functions
    
    private func addAttendeesByDictionary(attendeeDict: [String: String]) {
        _attendees.append(attendeeDict)
        self[AttendeesKey] = _attendees
    }
    
    private func addLoggedUserAsAttendee() {
        if let user = UserPersistenceStore.sharedStore.user {
            addAttendeesByDictionary([
                EmailKey: user.email,
                ResponseStatusKey: "accepted"
            ])
        }
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
        } else {
            self[StartKey] = [
                DateKey: startString,
                TimeZoneKey: timeZone
            ]
        }
        
        if var endDict = self[EndKey] as? [String: AnyObject] {
            endDict[DateKey] = endString
            endDict.removeValueForKey(DateTimeKey)
        } else {
            self[EndKey] = [
                DateKey: endString,
                TimeZoneKey: timeZone
            ]
        }        
    }
    
    private func cancelAllDay() {
        if var startDict = self[StartKey] as? [String: AnyObject], let startDate = startDate {
            startDict[DateTimeKey] = dateFormatter.stringFromDate(startDate)
            startDict.removeValueForKey(DateTimeKey)
        }
        
        if var endDict = self[EndKey] as? [String: AnyObject], let endDate = endDate {
            endDict[DateTimeKey] = dateFormatter.stringFromDate(endDate)
            endDict.removeValueForKey(DateTimeKey)
        }
    }
}
