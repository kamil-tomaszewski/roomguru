//
//  RevokeQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 05.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON

class RevokeQuerySpec: QuickSpec {
    
    override func spec() {
        
        var sut: RevokeQuery?
        let userEmail = "FixtureEmail"
        let eventIdentifier = "FixtureIdentifier"
       
        describe("when initializing with event") {
            
            context("event has proper identifier") {
                
                beforeEach {
                    var event = self.mockedEvent(eventIdentifier)
                    UserPersistenceStore.sharedStore.registerUserWithEmail(userEmail)
                    sut = RevokeQuery(event)
                }
            
                afterEach {
                    sut = nil
                    UserPersistenceStore.sharedStore.clear()
                }
            
                it("should have proper URL extension") {
                    let URLExtension = "/calendars/" + userEmail + "/events/" + eventIdentifier
                    expect(sut!.URLExtension).to(equal(URLExtension))
                }
            
                it("should have no parameters") {
                    expect(sut!.parameters).to(beNil())
                }
            }
            
            context("event has no identifier") {
                
                beforeEach {
                    let event = self.mockedEventWithNoIdentifier()
                    UserPersistenceStore.sharedStore.registerUserWithEmail(userEmail)
                    sut = RevokeQuery(event)
                }
                
                afterEach {
                    sut = nil
                    UserPersistenceStore.sharedStore.clear()
                }
                
                it("should have proper URL extension") {
                    let URLExtension = ""
                    expect(sut!.URLExtension).to(equal(URLExtension))
                }
                
                it("should have no parameters") {
                    expect(sut!.parameters).to(beNil())
                }
            }
            
            context("there is no user email stored") {
                
                beforeEach {
                    let event = self.mockedEvent(eventIdentifier)
                    UserPersistenceStore.sharedStore.clear()
                    sut = RevokeQuery(event)
                }
                
                afterEach {
                    sut = nil
                }
                
                it("should have proper URL extension") {
                    let URLExtension = ""
                    expect(sut!.URLExtension).to(equal(URLExtension))
                }
                
                it("should have no parameters") {
                    expect(sut!.parameters).to(beNil())
                }
            }
        }
    }
}

private extension RevokeQuerySpec {
    
    func mockedEvent(eventIdentifier: String) -> Event {
        
        return Event(json: JSON([
            "id" : eventIdentifier,
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
    
    func mockedEventWithNoIdentifier() -> Event {
        
        return Event(json: JSON([
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
