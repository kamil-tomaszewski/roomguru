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
import DateKit

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
            failure(error: NSError.errorWithMessage("Client ID is not set!"))
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
    
    func eventsList(forCalendar calendarID: String, success: (response: [Event]?) -> (), failure: ErrorBlock) {
    
        assert(self.clientID != "", "Client ID is not set!")
        
        let requestPath = serverURL + "/calendars/" + calendarID + "/events"
        
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.000Z'"
        formatter.timeZone = NSTimeZone(name: "Europe/Warsaw")
        
        let maxDate = NSDate().tomorrow.hour(23).minute(59).second(59).date
        let minDate = NSDate().midnight.days.substract(3).date
        
        let maxDateString: String = formatter.stringFromDate(maxDate)
        let minDateString: String = formatter.stringFromDate(minDate)
        
        let parameters: [String: AnyObject] = [
            "timeMax": maxDateString,
            "timeMin": minDateString,
            "orderBy": "startTime",
            "singleEvents": "true"
        ]
        
        var result: [Event] = []
        
        let request = Alamofire.request(.GET, requestPath + key(), parameters: parameters)
        request.resume(&result, requestPath, parameters, success, failure)
    }
    
    func freebusyList(calendars: Array<String>, success: ResponseBlock, failure: ErrorBlock) {
        
        if (self.clientID == "") {
            failure(error: NSError.errorWithMessage("Client ID is not set!"))
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

extension Request {
    
    var HTTPMethod: Alamofire.Method {
        get {
            if let method = self.request.HTTPMethod {
                return stringToHTTPMethod(method)
            }
            return Alamofire.Method.GET
        }
    }
    
    var URLString: String { get { return self.request.URLString } }
    var HTTPBody: AnyObject? {
        get {
            if let data = self.request.HTTPBody {
                var error: NSError?
                return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error)
            }
            return nil
        }
    }
    
}

extension Request {
    
    private func resume<T where T: ModelJSONProtocol>(inout result: [T],_ requestPath: String,_ parameters: [String: AnyObject],_ success: (response: [T]?) -> (), _ failure: ErrorBlock) {
        
        responseJSON { (request, response, json, error) -> Void in
                    
            if let responseError: NSError = error as NSError? {
                failure(error: responseError)
                return
            }
            
            if let responseJSON: AnyObject = json {
                var swiftyJSON: JSON? = nil
                
                Async.background {
                    swiftyJSON = JSON(responseJSON)
                    let array = swiftyJSON?["items"].array
                    
                    if let _array: [T] = T.map(array) {
                        result += _array
                    }
                }.main {
                    if let pageToken = swiftyJSON?["nextPageToken"].string {
                        self.nextPage(&result, pageToken: pageToken, requestPath: requestPath, parameters: parameters, success: success, failure: failure)
                    } else {
                        success(response: result)
                    }
                }
            } else {
                let description = "Failed retrieving data"
                let otherError = NSError(domain: "com.ngr.roomguru", code: -1, userInfo: [NSLocalizedDescriptionKey: description])
                
                failure(error: otherError)
            }
        }
        
    }
    
    private func nextPage<T where T: ModelJSONProtocol>(inout result: [T], pageToken: String, requestPath: String, var parameters: [String: AnyObject], success: (response: [T]?) -> (), failure: ErrorBlock) {
        
        parameters["pageToken"] = pageToken as AnyObject
        
        let request = Alamofire.request(self.HTTPMethod, requestPath, parameters: parameters)
        request.resume(&result, requestPath, parameters, success, failure)
    }
    
}

var page: Int = 0

extension Request {

    private func stringToHTTPMethod(method: String) -> Alamofire.Method {
        switch method {
        case "OPTIONS": return Alamofire.Method.OPTIONS
        case "GET":     return Alamofire.Method.GET
        case "HEAD":    return Alamofire.Method.HEAD
        case "POST":    return Alamofire.Method.POST
        case "PUT":     return Alamofire.Method.PUT
        case "PATCH":   return Alamofire.Method.PATCH
        case "DELETE":  return Alamofire.Method.DELETE
        case "TRACE":   return Alamofire.Method.TRACE
        case "CONNECT": return Alamofire.Method.CONNECT
        default: return Alamofire.Method.GET
        }
    }
    
}


private extension NetworkManager {
    
    private func nextPage(request: Request, pageToken: String, completion: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        request.request
    }

}

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
        
        var calendarsArray: Array<[String : AnyObject]> = Array<[String : AnyObject]>()
        
        for calendar in calendars {
            calendarsArray.append(["id" : calendar])
        }
        
        parameters["items"] = calendarsArray
        
        return parameters
    }
}
