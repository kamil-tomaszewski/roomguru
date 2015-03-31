//
//  NSErrorExtensions.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension NSError {
    
    convenience init(message: String) {
        self.init(domain: NSCocoaErrorDomain, code: 0, userInfo: ["message" : message])
    }
}
