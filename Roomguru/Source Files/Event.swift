//
//  Event.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import DateKit

class Event: ModelObject {
    var kind:       String?
    var etag:       String?
    var identifier: String?
    var status:     String?
    var htmlLink:   String?
    var createdAt:  String?
    var updatedAt:  String?
    var summary:    String?
    var location:   String?
    var startDate:  String?
    var endDate:    String?
    var hangoutLink: String?
    var iCalUID:    String?
    var attendees:  [Attendee]?
    var organizer:  Attendee?
    var rooms:      [Attendee]?
    
    var start:      NSDate?
    var end:        NSDate?
    var shortDate:  NSDate?
    
    var startTime:  String?
    var endTime:    String?
    
    override init() {
        super.init()
    }

    required init(json: JSON) {
        super.init(json: json)
    }
    
    override class func map<T where T: ModelJSONProtocol>(jsonArray: [JSON]?) -> [T]? {
        if let _jsonArray: [JSON] = jsonArray {
            if _jsonArray.isEmpty == true {
                return nil
            }
            return _jsonArray.map({ T(json: $0) })
        }
        
        return nil
    }

    
    override func toJSON() -> JSON {
        var json = JSON([])
        json["kind"].string = kind
        json["etag"].string = etag
        json["identifier"].string = identifier
        json["status"].string = status
        json["htmlLink"].string = htmlLink
        json["summary"].string = summary
        json["location"].string = location
        json["start"].string = startDate
        json["end"].string = endDate
        
        return json
    }
    
    override func map(json: JSON) {
        kind = json["kind"].string
        etag = json["etag"].string
        identifier = json["id"].string
        status = json["status"].string
        htmlLink = json["htmlLink"].string
        createdAt = json["created"].string
        updatedAt = json["updated"].string
        summary = json["summary"].string
        location = json["location"].string
        startDate = json["start"]["dateTime"].string
        endDate = json["end"]["dateTime"].string
        hangoutLink = json["hangoutLink"].string
        iCalUID = json["iCalUID"].string

        if let dict = json["creator"].dictionaryObject {
            organizer = Attendee()
            organizer?.map(JSON(dict))
        }
        
        let array = json["attendees"].arrayValue
        if let _array: [Attendee] = Attendee.map(array) {
            
            let copiedArray = _array

            attendees = _array.filter() { return !$0.isResource && !$0.isRoom }
            rooms = copiedArray.filter() { return $0.isRoom }
        }

        start = startDate?.date()
        end = endDate?.date()
        
        shortDate = startDate?.googleDateToShortDate()
        startTime = startDate?.shortTime()
        endTime = endDate?.shortTime()
    }
}

extension Event {
    
    class func sortedByDate(items: [Event]) -> [Event] {
        return items.sorted({
            if let firstDate = $0.start {
                if let secondDate = $1.start {
                    return firstDate.compare(secondDate).ascending
                }
            }
            return false
        })
    }
}

extension String {

    func googleDateToShortDateString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(date)        
    }
    
    func date() -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ZZZ"
        return formatter.dateFromString(self)
    }
    
    func shortTime() -> String? {
        if let date = self.date() {
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            return formatter.stringFromDate(date)
        }
        
        return nil
    }
    
    func googleDateToShortDate() -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ZZZZZ"
        
        if let _correctedDate = formatter.dateFromString(self) {
            formatter.dateFormat = "yyyy-MM-dd"
            let string = formatter.stringFromDate(_correctedDate)
            return formatter.dateFromString(string)
        }
        
        return nil
    }
}

@objc protocol StringConvertible {
    func string() -> String
}

extension NSDate: StringConvertible {
    
    func string() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(self)
    }
}
