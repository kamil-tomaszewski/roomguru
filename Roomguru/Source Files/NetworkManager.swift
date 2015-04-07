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
    
    func calendarsList(success: (calendars: [Calendar]) -> Void, failure: ErrorBlock) {
        
        if (self.clientID == "") {
            failure(error: NSError(message: "Client ID is not set!"))
        } else {
            
            let requestPath = serverURL + "/users/me/calendarList"
            
            Alamofire.request(.GET, requestPath + key()).responseJSON { (request, response, json, error) -> Void in
                
                if let responseJSON: AnyObject = json {
                    var swiftyJSON: JSON? = JSON(responseJSON)
                    
                    let array = swiftyJSON?["items"].array
                    
                    if let _array: [Calendar] = Calendar.map(array) {
                        success(calendars: _array)
                    }
                } else {
                    let _error = error? ?? NSError(message: NSLocalizedString("Unknown error occured", comment: ""))
                    failure(error: _error)
                }
            }
        }
    }
    
    func requestList<T: ModelJSONProtocol>(query: PageableQuery, success: (response: [T]?) -> (), failure: ErrorBlock) {
        query.setFullPath(serverURL, authKey: key())
        PageableRequest<T>(query).resume(success, failure)
    }
    
    func request(query: Query, success: ResponseBlock, failure: ErrorBlock) {
        query.setFullPath(serverURL, authKey: key())
        QueryRequest(query).resume(success, failure: failure)
    }
    
    /**
    Executes requests with provided queries. Number of request matches number of queries.
    Each request result has to conform to ModelJSONProtocol. The final result can be of any type.
    
    :param: queries is an array of PageableQuery to be perform one after another, ordered as provided
    :param: construct a block where results from each request can be processed, or transformed to some other type, and returned
    :param: success a block invoked if every request was succesful
    :param: failure a block invoked if error occur
    */
    func chainedRequest<T: ModelJSONProtocol, U>(queries: [PageableQuery], construct: (PageableQuery, [T]?) -> [U], success: [U]? -> (), failure: ErrorBlock) {
        
        var result: [U] = []
        var requestError: NSError?
        
        let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        let group: dispatch_group_t = dispatch_group_create();
        
        for query in queries {
            dispatch_group_enter(group)
            
            self.requestList(query, success: { (response: [T]?) -> () in
                result += construct(query, response)
                dispatch_group_leave(group)
                
            }, failure: { (error) -> () in
                failure(error: error)
                requestError = error
                dispatch_group_leave(group)
            })
        }
        
        dispatch_group_notify(group, queue) {
            if requestError == nil {
                success(result)
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
