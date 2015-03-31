//
//  NSURLExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 31/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import CryptoSwift

extension NSURL {
    
    class func gravatarURLWithEmail(email: String?) -> NSURL? {
        if let md5 = email?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).md5() {
            return NSURL(string: "http://www.gravatar.com/avatar/" + md5.lowercaseString + "?d=mm")
        }
        return nil;
    }
}
