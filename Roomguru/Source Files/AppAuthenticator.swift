//
//  AppAuthenticator.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class AppAuthenticator {
    
    func authenticateWithCompletion(completion: (success: Bool) -> Void) {
        
        var success: Bool
        
        // NGRTemp: Flags here written temporary
        if GPPSignIn.sharedInstance().hasAuthInKeychain() {
            
            if GPPSignIn.sharedInstance().trySilentAuthentication() {
                println("trySilentAuthentication")
                success = true
            } else {
                println("!! trySilentAuthentication")
                success = false
            }
        } else {
            println("!!!  hasAuthInKeychain")
            success = false
        }
        
        completion(success: success)
    }
}
