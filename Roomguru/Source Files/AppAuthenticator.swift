//
//  AppAuthenticator.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum Action {
    case Login, ChooseCalendars, Success
}

class AppAuthenticator: NSObject, GPPSignInDelegate {
    
    typealias authenticatorCompletionBlock = (action: Action, auth: GTMOAuth2Authentication? ,error: NSError?) -> Void
    
    private var completion: authenticatorCompletionBlock?
    private var action: Action = .Login
    
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

    func authenticateWithCompletion(completion: authenticatorCompletionBlock) {
        
        self.completion = completion
        var action: Action
        
        if GPPSignIn.sharedInstance().hasAuthInKeychain() {
            
            if !GPPSignIn.sharedInstance().trySilentAuthentication() {
                self.completion!(action: .Login, auth: nil, error: nil)
            }
            
        } else {
            self.completion!(action: .Login, auth: nil, error: nil)
        }
    }
    
    // MARK: GPPSignInDelegate Methods
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if (error != nil) {
            self.completion!(action: .Login, auth: nil, error: error)
        } else {
            let action: Action
            
            if CalendarPersistenceStore.sharedStore.calendars.count > 0 {
                action = .Success
            } else {
                action = .ChooseCalendars
            }
            
            self.completion!(action: action, auth: auth, error: nil)
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
         self.completion!(action: .Login, auth: nil, error: error)
    }
}
