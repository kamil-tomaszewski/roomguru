//
//  File.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

enum Status: String {
    case Awaiting = "needsAction", NotGoing = "declined" , Maybe = "tentative", Going = "accepted"
}

class Attendee: ModelObject {
    var name:    String?
    var email:   String?
    var status = Status(rawValue: "undefined")
    
    var isOrganizer = false
    var isResource  = false
    var isRoom      = false
    
    class func map(jsonArray: [JSON]?) -> [Attendee]? {
        if let _jsonArray: [JSON] = jsonArray {
            if _jsonArray.isEmpty == true {
                return nil
            }
            return _jsonArray.map({ Attendee(json: $0) })
        }
        
        return nil
    }
    
    override func toJSON() -> JSON {
        var json = JSON([])
        json["displayName"].string = name
        json["email"].string = email
        json["responseStatus"].string = status?.rawValue
        return json
    }
    
    override func map(json: JSON) {
        name = json["displayName"].string
        email = json["email"].string
        
        if let _string = json["responseStatus"].string {
            status = Status(rawValue: _string)
        }
        
        func assignIfExists(inout aBool: Bool, value: JSON, completion: () -> ()) {
            if value {
                aBool = value.boolValue
                completion()
            }
        }

        assignIfExists(&isResource, json["resource"]) {}
        assignIfExists(&isOrganizer, json["organizer"]) {}
        assignIfExists(&isRoom, json["self"]) { self.status = nil }
    }
}
