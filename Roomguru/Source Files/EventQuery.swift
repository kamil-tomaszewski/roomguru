//
//  EventQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 14/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire

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
    
    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String = "/calendars/primary/events", parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .JSON) {
        super.init(HTTPMethod, URLExtension: URLExtension, parameters: nil, encoding: encoding)
        status = .Confirmed
    }
    
    // MARK: Parameters
    
    var eventDescription: String? {
        get { return self[DescriptionKey] as? String }
        set { self[DescriptionKey] = newValue }
    }
    
    var recurrence: String? {
        get {
            if let recurrences = self[RecurrenceKey] as? [String] {
                return recurrences.first
            }
            return nil
        }
        set {
            if let recurrence = newValue {
                self[RecurrenceKey] = [recurrence]
            }
        }
    }
    
    // MARK: Keys
    
    private let DescriptionKey = "description"
    private let RecurrenceKey = "recurrence"
}
