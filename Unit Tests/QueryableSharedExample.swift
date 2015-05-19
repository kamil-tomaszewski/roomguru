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
            
            let sut = configDict["testQuery"] as! Query
            let mockQuery = configDict["mockQuery"] as! MockQuery
            
            let fixtureBaseURL = "FixtureBaseURL"
            let fixtureAuthKey = "FixtureAuthKey"
            
            let mockFullPath = fixtureBaseURL + sut.URLExtension + fixtureAuthKey
            
            sut.setFullPath(fixtureBaseURL, authKey: fixtureAuthKey)
            
            it("should have proper HTTP method") {
                expect(sut.HTTPMethod.rawValue).to(equal(mockQuery.HTTPMethod))
            }
            
            it("should have proper URL extension") {
                expect(sut.URLExtension).to(equal(mockQuery.URLExtension))
            }
            
            it("should have proper encoding") {
                var parameterEncodingAsString = self.stringForParameterEncoding(sut.encoding)
                expect(parameterEncodingAsString).to(equal(mockQuery.parameterEncoding))
            }
            
            it("should have proper full path") {
                expect(sut.fullPath).to(equal(mockFullPath))
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

func queryDateFormatter() -> NSDateFormatter {
    let formatter: NSDateFormatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatter.timeZone = NSTimeZone.localTimeZone()
    return formatter
}
