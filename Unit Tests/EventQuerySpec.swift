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
        
        describe("when initializing") {
           
            let mockQuery = MockQuery(HTTPMethod: "POST", URLExtension: "/calendars/primary/events", parameterEncoding: "JSON")
            var mockQueryParameters = [:]
            mockQueryParameters = ["status" : "confirmed"]
            
            let testQuery = EventQuery()
            
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
        
        describe("when setting event description") {
           
            let fixtureEventDescription = "FixtureEventDescription"
            
            var mockQueryParameters = [:]
            mockQueryParameters = ["status" : "confirmed", "description" : fixtureEventDescription]
            
            let testQuery = EventQuery()
            testQuery.eventDescription = fixtureEventDescription
          
            it("should have proper parameters") {
                expect(testQuery.parameters!).to(equal(mockQueryParameters))
            }
        }
        
        describe("when setting recurrence") {
            
            let fixtureRecurrence = "FixtureRecurrence"
                
            var mockQueryParameters = [:]
            mockQueryParameters = ["status" : "confirmed", "recurrence" : [fixtureRecurrence]]
                
            let testQuery = EventQuery()
            testQuery.recurrence = fixtureRecurrence
            
            it("should have proper parameters") {
                expect(testQuery.parameters!).to(equal(mockQueryParameters))
            }
        }
    }
}
