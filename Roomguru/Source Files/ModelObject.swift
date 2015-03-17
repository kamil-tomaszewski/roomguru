//
//  ModelObject.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol ModelJSONProtocol {
    func toJSON() -> JSON
    func map(json: JSON)
}

class ModelObject: NSObject, ModelJSONProtocol {

    init(json: JSON) {
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
    
}
