//
//  NSErrorExtensions.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension NSError {
    
    class private var NGRRoomguruErrorDomain: String { return "com.ngr.roomguru" }
    
    convenience init(message: String) {
        self.init(domain: NSError.NGRRoomguruErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : message])
    }
}
