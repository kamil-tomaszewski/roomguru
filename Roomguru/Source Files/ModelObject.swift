//
//  ModelObject.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol ModelJSONProtocol {
    
    init(json: JSON)
    
    func toJSON() -> JSON
    func map(json: JSON)
    
    class func map<T where T: ModelJSONProtocol>(jsonArray: [JSON]?) -> [T]?
}

class ModelObject: NSObject, ModelJSONProtocol {

    required init(json: JSON) {
        super.init()
        map(json)
    }
    
    func toJSON() -> JSON {
        assert(false, "|\(__FUNCTION__)| function not implemented")
        return JSON(NSData())
    }
    
    func map(json: JSON) {
        assert(false, "|\(__FUNCTION__)| function not implemented")
    }
    
    class func map<T>(jsonArray: [JSON]?) -> [T]? {
        assert(false, "|\(__FUNCTION__)| function not implemented")
        return nil
    }
    
}
