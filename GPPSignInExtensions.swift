//
//  GPPSignInExtensions.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 16.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

extension GPPSignIn {
    
    class func isUserSignedIn() -> Bool {
        return GPPSignIn.sharedInstance().authentication != nil
    }
    
    class func hasSilentAuthenticationSucceeded() -> Bool {
        return GPPSignIn.sharedInstance().trySilentAuthentication()
    }
    
}
