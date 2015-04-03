//
//  Calendar.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class Calendar: ModelObject {
    var accessRole: String?
    var name:       String?
    var etag:       String?
    var identifier: String?
    var kind:       String?
    var summary:    String?
    var timezone:   String?
    
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
        json["name"].string = name
        json["etag"].string = etag
        json["id"].string = identifier
        json["kind"].string = kind
        json["summary"].string = summary
        json["timeZone"].string = timezone
        return json
    }
    
    override func map(json: JSON) {
        accessRole = json["accessRole"].string
        name = json["name"].string
        etag = json["etag"].string
        identifier = json["id"].string
        kind = json["kind"].string
        summary = json["summary"].string
        timezone = json["timeZone"].string
    }
}
