//
//  EventQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 12.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

class EventQuerySpec: QuickSpec {
    
    override func spec() {
        
        var testQuery: EventQuery!
        let mockQuery = MockQuery(HTTPMethod: "POST", URLExtension: "/calendars/primary/events", parameterEncoding: "JSON")
        var mockQueryParameters = [:]
        mockQueryParameters = ["status" : "confirmed"]
        
        describe("when initializing") {
            testQuery = EventQuery()
            
            itBehavesLike("queryable") {
                [
                    "testQuery": testQuery,
                    "mockQuery": mockQuery,
                ]
            }
            
            it("should have proper parameters") {
                expect(testQuery.parameters!).to(equal(mockQueryParameters))
            }
        }
    }
}
