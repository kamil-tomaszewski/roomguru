//
//  GPPAuthenticator.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Async

class GPPAuthenticator: NSObject, GPPSignInDelegate {
    
    typealias AuthenticatorCompletionBlock = (authenticated: Bool, auth: GTMOAuth2Authentication? ,error: NSError?) -> Void
    
    private var completion: AuthenticatorCompletionBlock?
    
    override init() {
        super.init()
        
        let sharedSignIn = GPPSignIn.sharedInstance();
        sharedSignIn.clientID = Constants.GooglePlus.ClientID
        sharedSignIn.scopes = Constants.GooglePlus.Scope
        sharedSignIn.shouldFetchGoogleUserID = true
        sharedSignIn.shouldFetchGoogleUserEmail = true
        sharedSignIn.shouldFetchGooglePlusUser = true
        sharedSignIn.delegate = self
    }

    func authenticateWithCompletion(completion: AuthenticatorCompletionBlock) {
        
        self.completion = completion
        
        if GPPSignIn.sharedInstance().hasAuthInKeychain() {
            
            if !GPPSignIn.sharedInstance().trySilentAuthentication() {
                self.completion!(authenticated: false, auth: nil, error: nil)
            }
            
        } else {
            Async.main(after: 0.2) {
                self.completion!(authenticated: false, auth: nil, error: nil)
            }
        }
    }
    
    // MARK: GPPSignInDelegate Methods
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if (error != nil) {
            self.completion!(authenticated: false, auth: nil, error: error)
        } else {
            self.completion!(authenticated: true, auth: auth, error: nil)
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
         self.completion!(authenticated: false, auth: nil, error: error)
    }
}
