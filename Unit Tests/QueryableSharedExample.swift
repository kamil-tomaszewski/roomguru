//
//  QueryableSharedExample.swift
//  Roomguru
//
//  Created by Aleksander Popko on 10.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import Alamofire


class MockQuery {
    
    let HTTPMethod: String
    let URLExtension: String
    let parameterEncoding: String
    
    init(HTTPMethod: String, URLExtension: String, parameterEncoding: String) {
        self.HTTPMethod = HTTPMethod
        self.URLExtension = URLExtension
        self.parameterEncoding = parameterEncoding
    }
}

class QueryableSharedExample: QuickConfiguration {
    
    override class func configure(configuration: Configuration) {
        sharedExamples("queryable") { (sharedExampleContext: SharedExampleContext) in
            
            var configDict: [String: AnyObject] = sharedExampleContext() as! [String: AnyObject]
            
            let testQuery = configDict["testQuery"] as! Query
            let mockQuery = configDict["mockQuery"] as! MockQuery
            
            it("should have proper HTTP method") {
                expect(testQuery.HTTPMethod.rawValue).to(equal(mockQuery.HTTPMethod))
            }
            
            it("should have proper URL extension") {
                expect(testQuery.URLExtension).to(equal(mockQuery.URLExtension))
            }
            
            it("should have proper encoding") {
                var parameterEncodingAsString = self.stringForParameterEncoding(testQuery.encoding)
                expect(parameterEncodingAsString).to(equal(mockQuery.parameterEncoding))
            }
        }
    }
}

private extension QueryableSharedExample {
    class func stringForParameterEncoding(encoding: ParameterEncoding) -> String {
        switch encoding {
        case .URL: return "URL"
        case .JSON: return "JSON"
        default: return ""
        }
    }
}
