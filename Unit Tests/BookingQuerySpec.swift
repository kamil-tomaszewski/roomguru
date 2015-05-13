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

class BookingQuerySpec: QuickSpec {
    
    let fixtureCalendarID = "FixtureCalendarID"
    let fixtureSummary = "FixtureSummary"
    let fixtureEmailFirst = "FixtureEmail.1"
    let fixtureEmailSecond = "FixtureEmail.2"
    let fixtureEmailThird = "FixtureEmail.3"
    
    var fixtureStartDate: NSDate {
        return NSDate(timeIntervalSince1970: 0)
    }
    
    var fixtureEndDate: NSDate {
        return NSDate(timeIntervalSince1970: 240)
    }
    
    var fixtureEndDateAsString: String {
        return queryDateFormatter().stringFromDate(fixtureEndDate)
    }
    
    var fixtureStartDateAsString: String {
        return queryDateFormatter().stringFromDate(fixtureStartDate)
    }
    
    override func spec() {
        
        describe("when initializing with calendar entry") {
            
            var mockCalendarEntry = CalendarEntry(calendarID: self.fixtureCalendarID, event: self.mockedEvent())
            let mockQuery = MockQuery(HTTPMethod: "PUT", URLExtension: "/calendars/primary/events", parameterEncoding: "JSON")
            var mockQueryParameters = [:]
            
            mockQueryParameters =
                ["attendees":[
                    ["email" : self.fixtureEmailFirst],
                    ["email" : self.fixtureEmailSecond],
                    ["email" : self.fixtureEmailThird],
                    ["email" : self.fixtureCalendarID, "responseStatus" : "accepted"]],
                "end" : ["dateTime":self.fixtureEndDateAsString, "timeZone" : "Europe/Warsaw"],
                "start" : ["dateTime":self.fixtureStartDateAsString, "timeZone" : "Europe/Warsaw"],
                "summary" : self.fixtureSummary]
            
            let testQuery = BookingQuery(calendarEntry: mockCalendarEntry)
            
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
        
        describe("when initializing with calendar time frame and summary") {
            
            let timeFrame = TimeFrame(startDate: self.fixtureStartDate, endDate: self.fixtureEndDate, availability: .NotAvailable)
            let fixtureCalendarTimeFrame: CalendarTimeFrame = (timeFrame, self.fixtureCalendarID)
            
            let mockQuery = MockQuery(HTTPMethod: "POST", URLExtension: "/calendars/primary/events", parameterEncoding: "JSON")
            var mockQueryParameters = [:]
            mockQueryParameters =
                ["attendees" : [[
                    "email" : self.fixtureCalendarID,
                    "responseStatus" : "accepted" ]],
                "end" : [
                    "dateTime" : self.fixtureEndDateAsString,
                    "timeZone":"Europe/Warsaw"],
                "start" : [
                    "dateTime" : self.fixtureStartDateAsString,
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
            "start" : ["dateTime" : self.fixtureStartDateAsString],
            "end" : ["dateTime" : self.fixtureEndDateAsString],
            "attendees" : [
                mockedAttendeeJSONWithName("FixtureName.1", email: fixtureEmailFirst, status: .Awaiting),
                mockedAttendeeJSONWithName("FixtureName.2", email: fixtureEmailSecond, status: .Going),
                mockedAttendeeJSONWithName("FixtureName.3", email: fixtureEmailThird, status: .Maybe),
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
