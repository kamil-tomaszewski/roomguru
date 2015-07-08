//
//  ModelObject.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ModelJSONProtocol {
    
    init(json: JSON)
    
    func map(json: JSON)
    
    static func map<T: ModelJSONProtocol>(jsonArray: [JSON]?) -> [T]?
}

class ModelObject: NSObject, ModelJSONProtocol {

    override init() {}
    
    required init(json: JSON) {
        super.init()

        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ZZZZZ"
        formatter.timeZone = NSTimeZone.localTimeZone()

        map(json)
    }
    
    func map(json: JSON) {
        fatalError("|\(__FUNCTION__)| function not implemented")
    }
    
    class func map<T: ModelJSONProtocol>(jsonArray: [JSON]?) -> [T]? {
        if let jsonArray: [JSON] = jsonArray where !jsonArray.isEmpty {
            return jsonArray.map { T(json: $0) }
        }
        
        return nil
    }
    
    // MARK: Internal
    
    let formatter: NSDateFormatter = NSDateFormatter()
}
