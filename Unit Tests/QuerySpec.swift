//
//  QuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 14.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import Alamofire
import ObjectiveC


class QuerySpec: QuickSpec {

    override func spec() {
        
        let fixtureURLExtension = "FixtureURLExtension"
        
        describe("when initializing") {
            
            let mockQuery = MockQuery(HTTPMethod:"POST", URLExtension: fixtureURLExtension, parameterEncoding: "URL")
            let testQuery = Query(Alamofire.Method.POST, URLExtension: fixtureURLExtension, parameters: nil, encoding: .URL)
            
            itBehavesLike("queryable") {
                [
                    "testQuery": testQuery,
                    "mockQuery": mockQuery,
                ]
            }
            
            it("should have proper parameters") {
                expect(testQuery.parameters).to(beNil())
            }
        }
        
        describe("when setting full path") {
            
            let fixtureBaseURL = "FixtureBaseURL"
            let fixtureAuthKey = "FixtureAuthKey"
            
            let mockFullPath = fixtureBaseURL + fixtureURLExtension + fixtureAuthKey
            
            let testQuery = Query(Alamofire.Method.POST, URLExtension: fixtureURLExtension, parameters: nil, encoding: .URL)
            testQuery.setFullPath(fixtureBaseURL, authKey: fixtureAuthKey)

            it("should have proper full path URL") {
                expect(testQuery.fullPath).to(equal(mockFullPath))
            }
        }
    }
}
