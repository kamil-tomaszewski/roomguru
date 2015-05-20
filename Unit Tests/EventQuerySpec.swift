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
      
        var sut: EventQuery!
        
        describe("when initializing") {
           
            let mockQuery = MockQuery(HTTPMethod: "POST", URLExtension: "/calendars/primary/events", parameterEncoding: "JSON")
            var mockQueryParameters = [:]
            mockQueryParameters = ["status" : "confirmed"]
            
            sut = EventQuery()
            
            itBehavesLike("queryable") {
                [
                    "sut": sut,
                    "mockQuery": mockQuery,
                    "mockQueryParameters": mockQueryParameters
                ]
            }
        }
        
        describe("when setting event description") {
            
            let fixtureEventDescription = "FixtureEventDescription"
            
            var mockQueryParameters = [:]
            mockQueryParameters = ["status" : "confirmed", "description" : fixtureEventDescription]
            
            beforeEach {
                sut = EventQuery()
                sut.eventDescription = fixtureEventDescription
            }
            
            afterEach {
                sut = nil
            }
            
            it("should have proper parameters") {
                expect(sut.parameters!).to(equal(mockQueryParameters))
            }
        }
        
        describe("when setting recurrence") {
            
            let fixtureRecurrence = "FixtureRecurrence"
                
            var mockQueryParameters = [:]
            mockQueryParameters = ["status" : "confirmed", "recurrence" : [fixtureRecurrence]]
            
            beforeEach {
                sut = EventQuery()
                sut.recurrence = fixtureRecurrence
            }
            
            afterEach {
                sut = nil
            }
            
            it("should have proper parameters") {
                expect(sut.parameters!).to(equal(mockQueryParameters))
            }
        }
    }
}
