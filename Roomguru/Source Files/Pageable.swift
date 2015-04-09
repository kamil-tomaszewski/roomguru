//
//  Pageable.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire

protocol Pageable: Queryable {
    var pageToken: String? { get set }
}


class PageableQuery: Query, Pageable {
    
    // MARK: Initializers
    
    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .URL) {
        super.init(HTTPMethod, URLExtension: URLExtension, parameters: parameters, encoding: encoding)
    }
    
    // MARK: Query parameters
    
    var pageToken: String? {
        get { return self[PageTokenKey] as! String? }
        set { self[PageTokenKey] = newValue }
    }
    
    // MARK: Private
    
    private let PageTokenKey = "pageToken"
    
}
