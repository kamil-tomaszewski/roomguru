//
//  Event.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

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
    var shortDate:  NSDate?
    
    class func map(jsonArray: [JSON]?) -> [Event]? {
        if let _jsonArray: [JSON] = jsonArray {
            if _jsonArray.isEmpty == true {
                return nil
            }
            return _jsonArray.map({ Event(json: $0) })
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
        
        shortDate = startDate?.googleDateToShortDate()
    }
}

extension Event {
    
    class func sortedByDate(items: [Event]) -> [Event] {
        return items.sorted({
            if let secondDate = $1.shortDate {
                return $0.shortDate?.compare(secondDate) == NSComparisonResult.OrderedDescending
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
    
    func googleDateToShortDate() -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ZZZ"
        
        // Convert time zone information from +00:00 to +0000 format
        let correctedDateString = self.substringToIndex(advance(self.endIndex, -3)) + "00"
        let correctedDate = formatter.dateFromString(correctedDateString)
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let _correctedDate = correctedDate {
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

