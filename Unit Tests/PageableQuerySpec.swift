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
            let sut = PageableQuery(Alamofire.Method.POST, URLExtension: fixtureURLExtension, parameters: nil, encoding: .URL)
            
            itBehavesLike("queryable") {
                [
                    "sut": sut,
                    "mockQuery": mockQuery,
                ]
            }
            
            it("should have no page token") {
                expect(sut.pageToken).to(beNil())
            }
        }
        
        describe("when setting page token") {
            
            let fixturePageToken = "FixturePageToken"
            var mockParameters = [:]
            mockParameters = ["pageToken" : fixturePageToken]
            
            let sut = PageableQuery(Alamofire.Method.POST, URLExtension: fixtureURLExtension, parameters: nil, encoding: .URL)
            sut.pageToken = fixturePageToken
            
            it("should have proper parameters") {
                expect(sut.parameters).to(equal(mockParameters))
            }
        }
    }
}
