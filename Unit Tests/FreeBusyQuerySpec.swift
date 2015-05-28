//
//  FreeBusyQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 12.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import DateKit

class FreeBusyQuerySpec: QuickSpec {
    
    override func spec() {
        
        let fixtureCalendarIDs = ["FixtureCalendarID.1", "FixtureCalendarID.2", "FixtureCalendarID.3"]
        var sut: FreeBusyQuery!
        let mockQuery = MockQuery(HTTPMethod: "POST", URLExtension: "/freeBusy", parameterEncoding: "JSON")
        
        let fixtureSearchTimeRange: TimeRange = (min: NSDate().midnight, max: NSDate().midnight.days + 2)
        
        var fixtureTimeMin = queryDateFormatter().stringFromDate(fixtureSearchTimeRange.min)
        var fixtureTimeMax = queryDateFormatter().stringFromDate(fixtureSearchTimeRange.max)
        let fixtureTimeZone = "Europe/Warsaw"
        let fixtureItems = fixtureCalendarIDs.map { ["id": $0] }

        let mockQueryParameters = ["timeMax":fixtureTimeMax, "timeMin" : fixtureTimeMin, "timeZone" : fixtureTimeZone, "items" : fixtureItems]
        
        describe("when initializing") {
            sut = FreeBusyQuery(calendarsIDs: fixtureCalendarIDs, searchTimeRange: fixtureSearchTimeRange)
            
            itBehavesLike("queryable") {
                [
                    "sut": sut,
                    "mockQuery": mockQuery,
                    "mockQueryParameters": mockQueryParameters
                ]
            }
        }
    }
}
