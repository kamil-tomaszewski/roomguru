//
//  Attendee.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import SwiftyJSON

enum Status: String {
    case Awaiting = "needsAction", NotGoing = "declined" , Maybe = "tentative", Going = "accepted", Unknown = "unknown"
}

class Attendee: ModelObject, NSSecureCoding {
    var name:    String?
    var email:   String?
    var status:  Status = .Unknown
    
    var isOrganizer = false
    var isResource  = false
    var isRoom      = false
    
    required init(json: JSON) {
        super.init(json: json)
    }
    
    // MARK: NSSecureCoding
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObjectForKey("name") as? String
        self.email = aDecoder.decodeObjectForKey("email") as? String
        
        if let status = aDecoder.decodeObjectForKey("status") as? String {
            self.status = Status(rawValue: status) ?? .Unknown
        }
        
        self.isOrganizer = aDecoder.decodeBoolForKey("isOrganizer")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.status.rawValue, forKey: "status")
        aCoder.encodeBool(self.isOrganizer, forKey: "isOrganizer")
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
    
    // MARK: JSON
    
    override func toJSON() -> JSON {
        var json = JSON([:])
        json["displayName"].string = name
        json["email"].string = email
        json["responseStatus"].string = status.rawValue
        return json
    }
    
    override func map(json: JSON) {
        name = json["displayName"].string
        email = json["email"].string
        
        if let responseStatus = json["responseStatus"].string {
            status = Status(rawValue: responseStatus) ?? .Unknown
        }
        
        func assignIfExists(inout aBool: Bool, value: JSON) {
            if value {
                aBool = value.boolValue
            }
        }

        assignIfExists(&isResource, json["resource"])
        assignIfExists(&isOrganizer, json["organizer"])
        assignIfExists(&isRoom, json["self"])
    }
}
