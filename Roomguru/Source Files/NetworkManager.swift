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
    
    var serverURL = ""
    var clientID = ""
    private var key: String { return "?key=" + clientID }
    
    private var tokenStore: GPPTokenStore?
    
    class var sharedInstance: NetworkManager {
        struct Static {
            static let instance: NetworkManager = NetworkManager()
        }
        
        return Static.instance
    }
    
    // Enable token store AFTER receiving auth from Google
    func enableTokenStore(_ enable: Bool = true) {
        tokenStore = enable ? GPPTokenStore() : nil
        updateAuthorizationHeader()
    }
}

// MARK: Requests

extension NetworkManager {
    
    func request(query: Query, success: ResponseBlock, failure: ErrorBlock) {
        
        refreshTokenWithFailure(failure) {
            
            query.setFullPath(self.serverURL, authKey: self.key)
            QueryRequest(query).resume(success, failure: failure)
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
    func chainedRequest<T: ModelJSONProtocol, U>(queries: [PageableQuery], construct: (PageableQuery, [T]?) -> [U], success: [U]? -> Void, failure: ErrorBlock) {
        
        refreshTokenWithFailure(failure) {
            
            var result: [U] = []
            var requestError: NSError?
            
            let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            let group: dispatch_group_t = dispatch_group_create();
            
            for query in queries {
                dispatch_group_enter(group)
                
                self.requestList(query, success: { (response: [T]?)  in
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
}

private extension NetworkManager {
    
    func requestList<T: ModelJSONProtocol>(query: PageableQuery, success: (response: [T]?) -> (), failure: ErrorBlock) {
        
        query.setFullPath(self.serverURL, authKey: self.key)
        PageableRequest<T>(query).resume(success, failure)
    }
    
    func refreshTokenWithFailure(failure: ErrorBlock, success: VoidBlock) {
        
        tokenStore?.refreshTokenIfNeeded(id: clientID) { (didRefresh, error) in
            
            if didRefresh {
                self.updateAuthorizationHeader()
            }
            
            if let error = error {
                failure(error: error)
                
            } else {
                success()
            }
        }
    }
    
    func updateAuthorizationHeader() {
        
        if let tokenStore = tokenStore {
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": tokenStore.authorizationHeader()]
        } else {
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = nil
        }
    }
}
