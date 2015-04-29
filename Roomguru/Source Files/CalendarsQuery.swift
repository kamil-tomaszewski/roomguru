//
//  CalendarsQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire

class CalendarsQuery: Query {
    
    convenience init() {
        self.init(.GET, URLExtension: "/users/me/calendarList")
    }
    
    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .URL) {
        super.init(HTTPMethod, URLExtension: URLExtension, parameters: parameters, encoding: encoding)
    }
}
