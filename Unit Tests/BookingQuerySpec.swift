//
//  BookingQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 13.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON
import DateKit

class BookingQuerySpec: QuickSpec {
    
    let fixtureCalendarID = "FixtureCalendarID"
    let fixtureSummary = "FixtureSummary"
    
    override func spec() {
        
        describe("when initializing with calendar entry") {
            
            var mockCalendarEntry = CalendarEntry(calendarID: self.fixtureCalendarID, event: self.mockedEvent())
            let mockQuery = MockQuery(HTTPMethod: "PUT", URLExtension: "/calendars/primary/events", parameterEncoding: "JSON")
            let testQuery = BookingQuery(calendarEntry: mockCalendarEntry)
            
            itBehavesLike("queryable") {
                [
                    "testQuery": testQuery,
                    "mockQuery": mockQuery,
                ]
            }
            
            it("should have proper parameters") {
               // NGRTodo: implement query parameters testing
            }
        }
        
        describe("when initializing with calendar time frame and summary") {
            
            let startDate = NSDate(timeIntervalSince1970: 0)
            let endDate = NSDate(timeIntervalSince1970: 240)
        
            let endDateAsString = queryDateFormatter().stringFromDate(endDate)
            let startDateAsString = queryDateFormatter().stringFromDate(startDate)
            
            let timeFrame = TimeFrame(startDate: startDate, endDate: endDate, availability: .NotAvailable)
            let fixtureCalendarTimeFrame: CalendarTimeFrame = (timeFrame, self.fixtureCalendarID)
            
            let mockQuery = MockQuery(HTTPMethod: "POST", URLExtension: "/calendars/primary/events", parameterEncoding: "JSON")
            var mockQueryParameters = [:]
            mockQueryParameters =
                ["attendees" : [[
                    "email" : self.fixtureCalendarID,
                    "responseStatus" : "accepted" ]],
                "end" : [
                    "dateTime" : endDateAsString,
                    "timeZone":"Europe/Warsaw"],
                "start" : [
                    "dateTime" : startDateAsString,
                    "timeZone":"Europe/Warsaw"],
                "summary" : self.fixtureSummary]
            
            let testQuery = BookingQuery(calendarTimeFrame: fixtureCalendarTimeFrame, summary: self.fixtureSummary)
            
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

private extension BookingQuerySpec {

    func mockedEvent() -> Event {
        
        return Event(json: JSON([
            "id" : "Fixture Identifier",
            "summary" : fixtureSummary,
            "status" : "confirmed",
            "htmlLink" : "",
            "start" : ["dateTime" : "2015-04-24T01:00:00-07:00"],
            "end" : ["dateTime" : "2015-04-24T01:30:00-07:00"],
            "attendees" : [
                mockedAttendeeJSONWithName("FixtureName.1", email: "FixtureEmail.1", status: .Awaiting),
                mockedAttendeeJSONWithName("FixtureName.2", email: "FixtureEmail.2", status: .Going),
                mockedAttendeeJSONWithName("FixtureName.3", email: "FixtureEmail.3", status: .Maybe),
                mockedRoomJSONWithName("FixtureRoom.1", email: "FixtureRoomEmail.1"),
                mockedRoomJSONWithName("FixtureRoom.2", email: "FixtureRoomEmail.2")
            ],
            "creator" : mockedAttendeeJSONWithName("FixtureName.4", email: "FixtureEmail.4", status: .Going)
            ]))
    }
    
    func mockedAttendeeJSONWithName(name: String, email: String, status: Status) -> [String : String] {
        return [
            "email" : email,
            "responseStatus" : status.rawValue,
            "displayName" : name
        ]
    }
    
    func mockedRoomJSONWithName(name: String, email: String) -> [String : String] {
        return [
            "email" : email,
            "responseStatus" : Status.Going.rawValue,
            "displayName" : name,
            "self" : String(stringInterpolationSegment: true),
            "resource" : String(stringInterpolationSegment: true)
        ]
    }
}
