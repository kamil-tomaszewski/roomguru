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
import SwiftyJSON

class NetworkManager: NSObject {
    private var serverURL = ""
    private var clientID = ""
    private var key: String { return "?key=" + clientID }
    private var authenticator: GPPAuthenticator { return (UIApplication.sharedApplication().delegate as! AppDelegate).authenticator }
    
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
        return self.parameters["access_token"] as! String
    }
    
    private func tokenType() -> String {
        return self.parameters["token_type"] as! String
    }
    
    private func tokenForAuthorizationHeader() -> String {
        return self.tokenType() + " " + self.accessToken()
    }
}


// MARK: Requests

extension NetworkManager {
    
    func request(query: Query, success: ResponseBlock, failure: ErrorBlock) {
        
        authenticator.manuallyHandleTokenRefresh { (authenticated, error) in
            
            if authenticated {
                query.setFullPath(self.serverURL, authKey: self.key)
                QueryRequest(query).resume(success, failure: failure)
                
            } else {
                let error = NSError(message: "Session expired. Please log in again.")
                failure(error: error)
            }
        }
    }
    
    func requestList<T: ModelJSONProtocol>(query: PageableQuery, success: (response: [T]?) -> (), failure: ErrorBlock) {
        
        authenticator.manuallyHandleTokenRefresh { (authenticated, error) in
            
            if authenticated {
                query.setFullPath(self.serverURL, authKey: self.key)
                PageableRequest<T>(query).resume(success, failure)
                
            } else {
                let error = NSError(message: "Session expired. Please log in again.")
                failure(error: error)
            }
        }
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
                
            }, failure: { error in
                requestError = error
                dispatch_group_leave(group)
            })
        }
        
        dispatch_group_notify(group, queue) {
            if let requestError = requestError {
                failure(error: requestError)
            } else {
                success(result)
            }
        }
    }
}
