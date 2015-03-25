//
//  Requests.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire
import Async

class QueryRequest {
    
    var query: Queryable
    lazy var request: Alamofire.Request = self.createRequest()
    
    init(_ query: Queryable) {
        self.query = query
    }
    
    private func createRequest() -> Alamofire.Request {
        return Alamofire.request(query.HTTPMethod, query.fullPath, parameters: query.parameters)
    }
    
}

class PageableRequest<T: ModelJSONProtocol>: QueryRequest {
    
    var pageQuery: PageableQuery
    var result: [T]
    
    convenience init(_ query: PageableQuery) {
        self.init(query, results: [T]())
    }
    
    init(_ query: PageableQuery, results: [T]) {
        pageQuery = query
        result = results
        super.init(query)
    }
}

extension PageableRequest {
    
    func resume(success: (response: [T]?) -> (), _ failure: ErrorBlock) {
        
        request = createRequest()
        
        request.responseJSON { (request, response, json, error) -> Void in
            
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
                        self.result = _array
                    }
                }.main {
                    if let pageToken = swiftyJSON?["nextPageToken"].string {
                        self.pageQuery.pageToken = pageToken
                        self.resume(success, failure)
                    } else {
                        success(response: self.result)
                    }
                }
            } else {
                let description = NSLocalizedString("Failed retrieving data", comment: "")
                let otherError = NSError(domain: "com.ngr.roomguru", code: -1, userInfo: [NSLocalizedDescriptionKey: description])
                
                failure(error: otherError)
            }
        }
        
    }
    
}
