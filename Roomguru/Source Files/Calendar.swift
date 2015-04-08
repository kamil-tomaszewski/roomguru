//
//  Calendar.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class Calendar: ModelObject, NSSecureCoding, Equatable {
    
    private let kAccessRole = "accessRole"
    private let kSummary = "summary"
    private let kETag = "etag"
    private let kIdentifier = "identifier"
    private let kKind = "kind"
    private let kTimezone = "timezone"
    private let kName = "name"
    
    var accessRole: String?
    var summary:    String?
    var etag:       String?
    var identifier: String?
    var kind:       String?
    var timezone:   String?
    var name:       String?
    
    required init(json: JSON) {
        super.init(json: json)
    }
    
    // MARK: NSSecureCoding
    
    required init(coder aDecoder: NSCoder) {
        super.init()

        func decode(inout variable: String?, forKey key: String) {
            variable = aDecoder.decodeObjectForKey(key) as? String
        }
        
        decode(&accessRole, forKey: kAccessRole)
        decode(&summary, forKey: kSummary)
        decode(&etag, forKey: kETag)
        decode(&kind, forKey: kKind)
        decode(&timezone, forKey: kTimezone)
        decode(&identifier, forKey: kIdentifier)
        decode(&name, forKey: kName)
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(accessRole, forKey: kAccessRole)
        aCoder.encodeObject(summary, forKey: kSummary)
        aCoder.encodeObject(etag, forKey: kETag)
        aCoder.encodeObject(kind, forKey: kKind)
        aCoder.encodeObject(timezone, forKey: kTimezone)
        aCoder.encodeObject(identifier, forKey: kIdentifier)
        aCoder.encodeObject(name, forKey: kName)
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
    
    // MARK: JSON mapping
    
    class func map(jsonArray: [JSON]?) -> [Calendar]? {
        if let _jsonArray: [JSON] = jsonArray {
            if _jsonArray.isEmpty == true {
                return nil
            }
            return _jsonArray.map { Calendar(json: $0) }
        }
        
        return nil
    }
    
    override func toJSON() -> JSON {
        var json = JSON([])
        json["accessRole"].string = accessRole
        json["etag"].string = etag
        json["id"].string = identifier
        json["kind"].string = kind
        json["summary"].string = summary
        json["timeZone"].string = timezone
        return json
    }
    
    override func map(json: JSON) {
        accessRole = json["accessRole"].string
        etag = json["etag"].string
        identifier = json["id"].string
        kind = json["kind"].string
        summary = json["summary"].string
        timezone = json["timeZone"].string
        name = CalendarPersistenceStore.sharedStore.matchingCalendar(self)?.name
    }
}

// MARK: Equatable

func ==(lhs: Calendar, rhs: Calendar) -> Bool {
    return lhs.identifier == rhs.identifier
}

