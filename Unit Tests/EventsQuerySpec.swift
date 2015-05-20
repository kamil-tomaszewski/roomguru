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
        
        var fixtureTimeMin = queryDateFormatter().stringFromDate(timeRange.min)
        var fixtureTimeMax = queryDateFormatter().stringFromDate(timeRange.max)

        let mockQueryParameters = ["maxResults": 100, "orderBy" : "startTime", "singleEvents" : "true", "timeMax" : fixtureTimeMax, "timeMin" : fixtureTimeMin]

        describe ("when initializing single query with single calendar identifier") {
            let sut = EventsQuery(calendarID: fixtureCalendarIDs.first!, timeRange: timeRange)
            
            itBehavesLike("queryable") {
                [
                    "sut": sut,
                    "mockQuery": mockQueries.first!,
                    "mockQueryParameters": mockQueryParameters
                ]
            }
            
            it("should have proper time max") {
                expect(sut.timeMax).to(equal(timeRange.max))
            }
            
            it("should have proper time min") {
                expect(sut.timeMin).to(equal(timeRange.min))
            }
            
        }
        
        describe ("when creating array of queries from array of calendar identifiers") {
            let sut = EventsQuery.queriesForCalendarIdentifiers(fixtureCalendarIDs, withTimeRange: timeRange)

            it("should return proper number of queries") {
                expect(sut.count).to(equal(fixtureCalendarIDs.count))
            }
            
            for var i = 0; i < sut.count; i++ {
                let testQuery = sut[i]
                
                itBehavesLike("queryable") {
                    [
                        "sut": testQuery,
                        "mockQuery": mockQueries[i],
                        "mockQueryParameters": mockQueryParameters
                    ]
                }
                
                it("should have proper time max") {
                    expect(testQuery.timeMax).to(equal(timeRange.max))
                }
                
                it("should have proper time min") {
                    expect(testQuery.timeMin).to(equal(timeRange.min))
                }
            }
        }
    }
}
