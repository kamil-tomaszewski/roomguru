//
//  NetworkManager.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 12/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Alamofire
import Async

class NetworkManager: NSObject {
    private var serverURL = ""
    private var clientID = ""
    
    class var sharedInstance: NetworkManager {
        struct Static {
            static let instance: NetworkManager = NetworkManager()
        }
        
        return Static.instance
    }
    
    func setServerURL(serverURL: String) {
        self.serverURL = serverURL
    }
    
}


// MARK: Authentication

extension NetworkManager {
        
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

extension NetworkManager {
    
    func calendarsList(success: ResponseBlock, failure: ErrorBlock) {
        
        let requestPath = serverURL + "/users/me/calendarList"
        
        Alamofire.request(.GET, requestPath + key()).responseJSON { (request, response, json, error) -> Void in
            if let responseError = error {
                failure(error: responseError)
            } else {
                if let responseJSON: AnyObject = json {
                    success(response: JSON(responseJSON))
                }
            }
        }
    }
    
    func eventsList(forCalendar calendarID: String, success: RGRResponseBlock, failure: RGRErrorBlock) {
        let requestPath = serverURL + "/calendars/" + calendarID + "/events"
        
        Alamofire.request(.GET, requestPath + key()).responseJSON { (request, response, json, error) -> Void in
            if let responseError = error {
                failure(error: responseError)
            } else {
                if let responseJSON: AnyObject = json {
                    var swiftyJSON: JSON? = nil
                    
                    Async.background {
                        swiftyJSON = JSON(responseJSON)
                    }.main {
                        success(response: swiftyJSON)
                    }
                }
            }
        }
    }
}

// MARK: Private

private extension NetworkManager {

    private func key() -> String {
        return "?key=" + clientID
    }
    
}
