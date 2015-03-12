//
//  RGRNetworkManager.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 12/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Alamofire

class RGRNetworkManager: NSObject {
    private var serverURL = ""
    private var clientID = ""
    
    class var sharedInstance: RGRNetworkManager {
        struct Static {
            static let instance: RGRNetworkManager = RGRNetworkManager()
        }
        
        return Static.instance
    }
    
    func setServerURL(serverURL: String) {
        self.serverURL = serverURL
    }
    
}


// MARK: Authentication

extension RGRNetworkManager {
        
    func setAuthentication(token: GTMOAuth2Authentication) {
        self.clientID = token.clientID
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": token.tokenForAuthorizationHeader()]
    }
    
}

private extension GTMOAuth2Authentication {

    private func accessToken() -> String {
        return self.parameters["access_token"] as String
    }
    
    private func tokenType() -> String {
        return self.parameters["token_type"] as String
    }
    
    private func tokenForAuthorizationHeader() -> String {
        return self.tokenType() + " " + self.accessToken()
    }
    
}


// MARK: Requests

extension RGRNetworkManager {
    
    func calendarsList(success: RGRResponseBlock, failure: RGRErrorBlock) {
        
        let requestPath = serverURL + "/users/me/calendarList"
        
        Alamofire.request(.GET, requestPath + key()).responseJSON { (request, response, json, error) -> Void in
            if let responseError = error {
                failure(error: responseError)
            } else {
                success(response: json)
            }
        }
    }
}

// MARK: Helpers

extension RGRNetworkManager {
    
    class func isUserSignedIn() -> Bool {
        return GPPSignIn.sharedInstance().authentication != nil
    }
    
    class func hasSilentAuthenticationSucceeded() -> Bool {
        return GPPSignIn.sharedInstance().trySilentAuthentication()
    }
    
}

// MARK: Private

private extension RGRNetworkManager {

    private func key() -> String {
        return "?key=" + clientID
    }
    
}
