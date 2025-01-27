//
//  RevokeQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 01/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire

class RevokeQuery: Query {
    
    convenience init(eventID: String, userEmail: String) {
        var URLExtension = "/calendars/" + userEmail + "/events/" + eventID
        self.init(.DELETE, URLExtension: URLExtension)
    }

    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .URL) {
        super.init(HTTPMethod, URLExtension: URLExtension, parameters: parameters, encoding: encoding)
    }
}
