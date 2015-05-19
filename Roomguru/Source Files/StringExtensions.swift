//
//  StringExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 09/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension String {
    
    var length: Int {
        return count(self)
    }
    
    func lengthByTrimmingWhitespaceCharacters() -> Int {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).length
    }
    
    var uppercaseFirstLetter: String {
        
        if length == 0 { return self }
        
        let foundationString = self as NSString
        let firstLetter = foundationString.substringToIndex(1).uppercaseString
        return foundationString.stringByReplacingCharactersInRange(NSMakeRange(0, 1), withString: firstLetter)
    }
}
