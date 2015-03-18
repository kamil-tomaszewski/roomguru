//
//  Freebusy.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 18.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class Freebusy: ModelObject {
    var timeMin:    String?
    var timeMax:    String?
    var timeZone:   String?
    var identifier: String?
    
    class func map(jsonArray: [JSON]?) -> [Freebusy]? {
        if let _jsonArray: [JSON] = jsonArray {
            if _jsonArray.isEmpty == true {
                return nil
            }
            return _jsonArray.map({ Freebusy(json: $0) })
        }
        
        return nil
    }
    
    override func toJSON() -> JSON {
        var json = JSON([])
        json["timeMin"].string = timeMin
        json["timeMax"].string = timeMax
        json["timeZone"].string = timeZone
        json["id"].string = identifier
        return json
    }
    
    override func map(json: JSON) {
        timeMin = json["timeMin"].string
        timeMax = json["timeMax"].string
        timeZone = json["timeZone"].string
        identifier = json["id"].string
    }
}
