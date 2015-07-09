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
    
    // API stored properties:
    private(set) var kind:       String?
    private(set) var etag:       String?
    private(set) var identifier: String?
    private(set) var status:     String?
    private(set) var htmlLink:   String?
    private(set) var createdAt:  String?
    private(set) var updatedAt:  String?
    private(set) var summary:    String?
    private(set) var location:   String?
    private(set) var hangoutLink:String?
    private(set) var iCalUID:    String?
    private(set) var eventDescription: String?
    private(set) var startDate:  String!
    private(set) var endDate:    String!
    private(set) var creator:    Attendee?
    private(set) var attendees:  [Attendee] = []
    private(set) var rooms:      [Attendee] = []
    
    // Properties based on API:
    private(set) var startTime:  String!
    private(set) var endTime:    String!
    
    var start: NSDate! {
        didSet {
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            startTime = formatter.stringFromDate(start)
        }
    }
    var end: NSDate! {
        didSet {
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            endTime = formatter.stringFromDate(end)
        }
    }

    // Computed properties:
    var duration: NSTimeInterval { return NSDate.timeIntervalBetweenDates(start: start, end: end) }

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
        self.attendees = aDecoder.decodeObjectForKey("attendees") as! [Attendee]
        
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
        eventDescription = json["description"].string
        
        creator = Attendee(json: json["creator"])
        
        let array = json["attendees"].arrayValue
        if let array: [Attendee] = Attendee.map(array) {
            
            let copiedArray = array

            attendees = array.filter { !$0.isResource && !$0.isRoom }
            rooms = copiedArray.filter { $0.isRoom }
        }

        start = startDate.date()
        end = endDate.date()
    }
}

extension Event {
    
    func isCanceled() -> Bool {
        return rooms.filter { ($0.status as Status) == .NotGoing }.count > 0
    }
    
    func setCustomSummary(text: String) {
        summary = text
    }
}

private extension String {
    
    func date() -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ZZZ"
        return formatter.dateFromString(self)!
    }
}

extension NSDate: StringConvertible {
    
    func string() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(self)
    }
}
