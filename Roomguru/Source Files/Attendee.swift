//
//  File.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class Attendee: ModelObject {
    var name:    String?
    var email:   String?
    var status:  String?
    
    var isOrganizer = false
    var isHuman     = true
    
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
        json["responseStatus"].string = status
        return json
    }
    
    override func map(json: JSON) {
        name = json["displayName"].string
        email = json["email"].string
        status = json["responseStatus"].string

        if json["resource"] {
            isHuman = !json["resource"].boolValue
        }
        
        if json["organizer"] {
            isOrganizer = json["organizer"].boolValue
        }
    }
}
