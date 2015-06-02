//
//  StringExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 09/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum EmailComparisionPart {
    case Local, Domain
}

extension String {
    
    var length: Int {
        return count(self)
    }
    
    var uppercaseFirstLetter: String {
        
        if length == 0 { return self }
        
        let foundationString = self as NSString
        let firstLetter = foundationString.substringToIndex(1).uppercaseString
        return foundationString.stringByReplacingCharactersInRange(NSMakeRange(0, 1), withString: firstLetter)
    }
    
    func lengthByTrimmingWhitespaceCharacters() -> Int {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).length
    }
    
    func isEqualToEmail(email: String, comparisionPart: EmailComparisionPart? = nil) -> Bool {
    
        if let comparisionPart = comparisionPart, rangeOfAtSignInSelf = rangeOfString("@"), rangeOfAtSignInEmail = email.rangeOfString("@") {
            
            switch comparisionPart {
            case .Local:
                let a = substringToIndex(rangeOfAtSignInSelf.startIndex)
                let b = email.substringToIndex(rangeOfAtSignInEmail.startIndex)
                return a == b
                
            case .Domain:
                let a = substringFromIndex(rangeOfAtSignInSelf.endIndex)
                let b = email.substringFromIndex(rangeOfAtSignInEmail.endIndex)
                return a == b
            }
        }
        
        return self == email
    }
}
