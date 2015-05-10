//
//  CalendarsQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 05.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import Alamofire

class CalendarsQuerySpec: QuickSpec {
    
    override func spec(){
        
        var testQuery: CalendarsQuery!
        let mockQuery = MockQuery(HTTPMethod: "GET", URLExtension: "/users/me/calendarList", parameterEncoding: "URL")
        
        describe("when initializing") {
            testQuery = CalendarsQuery()
            
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
    }
}
