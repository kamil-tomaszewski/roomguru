//
//  Query.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire


protocol Queryable {
    init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters?, encoding: Alamofire.ParameterEncoding)
    
    var HTTPMethod: Alamofire.Method { get }
    var URLExtension: String { get }
    var parameters: QueryParameters? { get }
    var fullPath: String { get }
    var encoding: Alamofire.ParameterEncoding { get }
}


protocol GoogleRequiredAuthProtocol {
    func setFullPath(baseUrl: String, authKey: String)
}


class Query: Queryable {
    
    // MARK: Initializers
    
    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .URL) {
        _HTTPMethod = HTTPMethod
        _URLExtension = URLExtension
        _parameters = parameters
        _encoding = encoding
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = NSTimeZone.localTimeZone()
    }
 
    // MARK: Query parameters
    
    var HTTPMethod: Alamofire.Method { get { return _HTTPMethod } }
    var URLExtension: String { get { return _URLExtension } }
    var parameters: QueryParameters? { get { return _parameters } }
    var fullPath: String { get { return _fullPath } }
    var encoding: Alamofire.ParameterEncoding { get { return _encoding } }
    
    // MARK: Internal
    
    let formatter: NSDateFormatter = NSDateFormatter()
    
    // MARK: Private
    
    private var _HTTPMethod: Alamofire.Method
    private var _URLExtension: String
    private var _parameters: QueryParameters? = nil
    private var _fullPath = ""
    private var _encoding: Alamofire.ParameterEncoding
}


// MARK: Subscripting

extension Query {
    
    subscript(key: String) -> AnyObject? {
        get { return _parameters?[key] as AnyObject? }
        set {
            if _parameters == nil {
                _parameters = QueryParameters()
            }
            _parameters?[key] = newValue
        }
    }
    
}


// MARK: GoogleRequiredAuthProtocol

extension Query: GoogleRequiredAuthProtocol {
    
    func setFullPath(baseUrl: String, authKey: String) {
        _fullPath = baseUrl + self.URLExtension + authKey
    }
    
}
