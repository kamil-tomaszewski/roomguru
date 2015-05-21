//
//  EventDetailsViewModelSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 24/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON

class EventDetailsViewModelSpec: QuickSpec {
    override func spec() {
        
        var sut: EventDetailsViewModel!
        
        describe("when initializing with event") {
            
            beforeEach {
                sut = EventDetailsViewModel(event: self.mockedEvent())
            }
            
            afterEach {
                sut = nil
            }
            
            it("should have proper number of guests") {
                expect(sut.numberOfGuests()).to(equal(3))
            }

            it("should have proper number of locations") {
                expect(sut.numberOfLocations()).to(equal(2))
            }
            
            it("should owner info be properly given") {
                let owner = sut.owner()
                expect(owner.email).to(equal("FixtureEmail.4"))
                expect(owner.name).to(equal("FixtureName.4"))
                expect(owner.status?.rawValue).to(equal("accepted"))
            }
            
            it("should icon for existing status be not nil") {
                expect(sut.iconWithStatus(.Going)).toNot(beNil())
            }
            
            it("should icon for non existing status be nil") {
                expect(sut.iconWithStatus(nil)).to(beNil())
            }
            
            it("should location be properly set") {
                let location = sut.location(0)
                expect(location.name).to(equal("FixtureRoom.1"))
                expect(location.email).to(equal("FixtureRoomEmail.1"))
            }
            
            it("should have properly formatted dates in summary") {
                let summary = sut.summary().string
                expect(summary).to(contain("April, 24 Fri 2015"))
                expect(summary).to(contain("10:00 AM"))
                expect(summary).to(contain("10:30 AM"))
                expect(summary).to(contain("Fixture summary"))
            }
        }
    }
}

private extension EventDetailsViewModelSpec {
    
    func mockedEvent() -> Event {
        
        return Event(json: JSON([
            "identifier" : "Fixture Identifier",
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
