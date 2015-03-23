//
//  NSErrorExtensions.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension NSError {
    
    class func errorWithMessage(message: String) -> NSError {
        let error: NSError = NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: ["message" : message])
        return error
    }
    
}
