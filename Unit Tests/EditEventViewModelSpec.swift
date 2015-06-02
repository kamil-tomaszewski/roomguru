//
//  EditEventViewModelSpec.swift
//  Roomguru
//
//  Created by Wojciech Trzasko on 29.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON

class EditEventViewModelSpec: QuickSpec {
    override func spec() {
        
        describe("initializing with calendar entry") {
            
            var sut: EditEventViewModel<GroupItem>!
            
            beforeEach {
                sut = EditEventViewModel(calendarEntry: self.mockedCalendarEntry())
            }
            
            afterEach {
                sut = nil
            }
            
            it("should has edit event title") {
                expect(sut.title).to(contain("Edit Event"))
            }
            
            it("should return validation error") {
                expect(sut.isModelValid()).toNot(beNil())
            }
        }
        
        describe("initializing without calendar entry") {
            
            var sut: EditEventViewModel<GroupItem>!
            
            beforeEach {
                sut = EditEventViewModel(calendarEntry: nil)
            }
            
            afterEach {
                sut = nil
            }
            
            it("should has new event title") {
                expect(sut.title).to(contain("New Event"))
            }
        }
        
    }
}

private extension EditEventViewModelSpec {
    
    func mockedCalendarEntry() -> CalendarEntry {
        return CalendarEntry(calendarID: "Fixture Identifier", event: mockedEvent());
    }
    
    func mockedEvent() -> Event {
        
        return Event(json: JSON([
            "id" : "Fixture Identifier",
            "summary" : "Fixture summary",
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
