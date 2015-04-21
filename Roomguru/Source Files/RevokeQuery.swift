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
    
    convenience init(_ entry: CalendarEntry) {
        
        var URLExtension = ""

        if let eventID = entry.event.identifier as String?, userEmail = UserPersistenceStore.sharedStore.user?.email as String? {
            URLExtension = "/calendars/" + userEmail + "/events/" + eventID
        }
        
        self.init(.DELETE, URLExtension: URLExtension)
    }

    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .URL) {
        super.init(HTTPMethod, URLExtension: URLExtension, parameters: parameters, encoding: encoding)
    }
    
}
