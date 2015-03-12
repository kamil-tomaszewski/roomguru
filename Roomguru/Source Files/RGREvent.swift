//
//  RGREvent.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class RGREvent: RGRModelObject {
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
    
    class func map(jsonArray: [JSON]?) -> [RGREvent]? {
        if let _jsonArray: [JSON] = jsonArray {
            if _jsonArray.isEmpty == true {
                return nil
            }
            return _jsonArray.map({ RGREvent(json: $0) })
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
    }
}
