//
//  Event.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import DateKit
import SwiftyJSON

class Event: ModelObject, NSSecureCoding {
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
    var hangoutLink:String?
    var iCalUID:    String?
    var attendees:  [Attendee]?
    var creator:    Attendee?
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
    
    // MARK: NSSecureCoding
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        
        self.kind = aDecoder.decodeObjectForKey("kind") as? String
        self.etag = aDecoder.decodeObjectForKey("etag") as? String
        self.identifier = aDecoder.decodeObjectForKey("identifier") as? String
        self.status = aDecoder.decodeObjectForKey("status") as? String
        self.htmlLink = aDecoder.decodeObjectForKey("htmlLink") as? String
        self.createdAt = aDecoder.decodeObjectForKey("createdAt") as? String
        self.updatedAt = aDecoder.decodeObjectForKey("updatedAt") as? String
        self.summary = aDecoder.decodeObjectForKey("summary") as? String
        self.location = aDecoder.decodeObjectForKey("location") as? String
        self.startDate = aDecoder.decodeObjectForKey("startDate") as? String
        self.endDate = aDecoder.decodeObjectForKey("endDate") as? String
        self.hangoutLink = aDecoder.decodeObjectForKey("hangoutLink") as? String
        self.iCalUID = aDecoder.decodeObjectForKey("iCalUID") as? String
        self.attendees = aDecoder.decodeObjectForKey("attendees") as? [Attendee]
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.kind, forKey: "kind")
        aCoder.encodeObject(self.etag, forKey: "etag")
        aCoder.encodeObject(self.identifier, forKey: "identifier")
        aCoder.encodeObject(self.status, forKey: "status")
        aCoder.encodeObject(self.htmlLink, forKey: "htmlLink")
        aCoder.encodeObject(self.createdAt, forKey: "createdAt")
        aCoder.encodeObject(self.updatedAt, forKey: "updatedAt")
        aCoder.encodeObject(self.summary, forKey: "summary")
        aCoder.encodeObject(self.location, forKey: "location")
        aCoder.encodeObject(self.startDate, forKey: "startDate")
        aCoder.encodeObject(self.endDate, forKey: "endDate")
        aCoder.encodeObject(self.hangoutLink, forKey: "hangoutLink")
        aCoder.encodeObject(self.iCalUID, forKey: "iCalUID")
        aCoder.encodeObject(self.attendees, forKey: "attendees")
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
    
    // MARK: JSON
    
    override class func map<T where T: ModelJSONProtocol>(jsonArray: [JSON]?) -> [T]? {
        if let _jsonArray = jsonArray {
            if _jsonArray.isEmpty {
                return nil
            }
            /* DISCLAIMER:
                Maping using T type failes with crash: "partial apply forwarder for Roomguru.Event"
                That's why explicit init and casting in map() function is needed.
            */
            return _jsonArray.map { Event(json: $0) as! T }
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

        creator = Attendee(json: json["creator"])
        
        let array = json["attendees"].arrayValue
        if let _array: [Attendee] = Attendee.map(array) {
            
            let copiedArray = _array

            attendees = _array.filter { !$0.isResource && !$0.isRoom }
            rooms = copiedArray.filter { $0.isRoom }
        }

        start = startDate?.date()
        end = endDate?.date()
        
        shortDate = startDate?.googleDateToShortDate()
        startTime = startDate?.shortTime()
        endTime = endDate?.shortTime()
    }
}

extension Event {
    
    func isCanceled() -> Bool {
        if let _rooms = rooms {
            return _rooms.filter {
                if let _status = $0.status {
                    return _status == .NotGoing
                }
                return false
            }.count > 0
        }
        return true
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
