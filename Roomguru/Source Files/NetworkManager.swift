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
        
        if (self.clientID == "") {
            failure(error: NSError(message: "Client ID is not set!"))
        } else {
            
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
    }
    
    func eventsList(query: EventsQuery, success: (response: [Event]?) -> (), failure: ErrorBlock) {

        assert(self.clientID != "", "Client ID is not set!")
        
        query.setFullPath(serverURL, authKey: key())
        PageableRequest<Event>(query).resume(success, failure)
        
    }
    
    func freebusyList(calendars: Array<String>, success: ResponseBlock, failure: ErrorBlock) {
        
        if (self.clientID == "") {
            failure(error: NSError(message: "Client ID is not set!"))
        } else {
            let parameters = self.parametersForFreebusy(calendars)
            let requestPath = serverURL + "/freeBusy/"
            
            Alamofire.request(.POST, requestPath + key(), parameters: parameters, encoding:ParameterEncoding.JSON).responseJSON { (request, response, json, error) -> Void in
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

}

// MARK: Private

private extension NetworkManager {

    private func key() -> String {
        return "?key=" + clientID
    }
    
    private func parametersForFreebusy(calendars: Array<String>) -> [String: AnyObject]? {
        
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.000Z'"
        formatter.timeZone = NSTimeZone(name: "Europe/Warsaw")

        let twoDaysTimeInterval: NSTimeInterval = 3600 * 48
        
        let timeMinString: String = formatter.stringFromDate(NSDate())
        let timeMaxString: String = formatter.stringFromDate(NSDate(timeIntervalSinceNow: twoDaysTimeInterval))
        
        var parameters: [String : AnyObject] = [
            "timeMin" : timeMinString,
            "timeMax" : timeMaxString,
            "timeZone" : "Europe/Warsaw"
        ]
        
        var calendarsArray = [[String: AnyObject]]()
        
        for calendar in calendars {
            calendarsArray.append(["id" : calendar])
        }
        
        parameters["items"] = calendarsArray
        
        return parameters
    }
}
