//
//  EventsQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 11.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

class EventsQuerySpec: QuickSpec {
    
    override func spec() {
        
        let fixtureCalendarIDs = ["FixtureCalendarID.1", "FixtureCalendarID.2", "FixtureCalendarID.3"]
        let timeRange: TimeRange = (NSDate(timeIntervalSince1970: 0), NSDate(timeIntervalSince1970: 240))
        var mockQueries: [MockQuery] = []
        for calendarID in fixtureCalendarIDs {
            let URLExtension = "/calendars/" + calendarID + "/events"
            let mockQuery = MockQuery(HTTPMethod: "GET", URLExtension: URLExtension, parameterEncoding: "URL")
            mockQueries.append(mockQuery)
        }

        describe ("when initializing single query with single calendar identifier") {
            let testQuery = EventsQuery(calendarID: fixtureCalendarIDs.first!, timeRange: timeRange)
            
            itBehavesLike("queryable") {
                [
                    "testQuery": testQuery,
                    "mockQuery": mockQueries.first!,
                ]
            }
            
            it("should have proper time max") {
                expect(testQuery.timeMax).to(equal(timeRange.max))
            }
            
            it("should have proper time min") {
                expect(testQuery.timeMin).to(equal(timeRange.min))
            }
            
            it("should have proper parameters") {
                // NGRTodo: testing query paramaters needs to be implemented:
            }
        }
        
        describe ("when creating array of queries from array of calendar identifiers") {
            let testQueries = EventsQuery.queriesForCalendarIdentifiers(fixtureCalendarIDs, withTimeRange: timeRange)

            it("should return proper number of queries") {
                expect(testQueries.count).to(equal(fixtureCalendarIDs.count))
            }
            
            for var i = 0; i < testQueries.count; i++ {
                let testQuery = testQueries[i]
                
                itBehavesLike("queryable") {
                    [
                        "testQuery": testQuery,
                        "mockQuery": mockQueries[i],
                    ]
                }
                
                it("should have proper time max") {
                    expect(testQuery.timeMax).to(equal(timeRange.max))
                }
                
                it("should have proper time min") {
                    expect(testQuery.timeMin).to(equal(timeRange.min))
                }
                
                it("should have proper parameters") {
                    // NGRTodo: testing query paramaters needs to be implemented
                }
            }
        }
    }
}
