//
//  PageableQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 14.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import Alamofire


class PageableQuerySpec: QuickSpec {
    
    override func spec() {

        let fixtureURLExtension = "FixtureURLExtension"
        
        describe("when initializing") {
            
            let mockQuery = MockQuery(HTTPMethod:"POST", URLExtension: fixtureURLExtension, parameterEncoding: "URL")
            let testQuery = PageableQuery(Alamofire.Method.POST, URLExtension: fixtureURLExtension, parameters: nil, encoding: .URL)
            
            itBehavesLike("queryable") {
                [
                    "testQuery": testQuery,
                    "mockQuery": mockQuery,
                ]
            }
            
            it("should have proper parameters") {
                expect(testQuery.parameters).to(beNil())
            }
            
            it("should have no page token") {
                expect(testQuery.pageToken).to(beNil())
            }
        }
        
        describe("when setting page token") {
            
            let fixturePageToken = "FixturePageToken"
            var mockParameters = [:]
            mockParameters = ["pageToken" : fixturePageToken]
            
            let testQuery = PageableQuery(Alamofire.Method.POST, URLExtension: fixtureURLExtension, parameters: nil, encoding: .URL)
            testQuery.pageToken = fixturePageToken
            
            it("should have proper parameters") {
                expect(testQuery.parameters).to(equal(mockParameters))
            }
        }
    }
}
