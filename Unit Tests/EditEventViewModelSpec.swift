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
        
        var sut: EditEventViewModel<GroupItem>!
        
        describe("initializing with calendar entry") {
            
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
            
            context("when resign first responder on items") {
                
                beforeEach {
                    sut.resignFirstResponderOnItems()
                }
                
                it("should not have first responder") {
                    expect(sut.summaryItem.shouldBeFirstResponder).toEventually(beFalsy())
                }
            }
            
            describe("after filling form with data") {
                
                beforeEach {
                    sut.summaryItem.text = "Fixture summary"
                    sut.startDateItem.date = NSDate()
                    sut.endDateItem.date = NSDate(timeIntervalSinceNow: 30000)
                    sut.calendarItem.result = "Fixture result"
                }
                
                it("should not return validation error when everthing is valid ") {
                    expect(sut.isModelValid()).to(beNil())
                }
                
                context("when summary is too short") {
                    
                    beforeEach {
                        sut.summaryItem.text = "A"
                    }
                    
                    it("should return validation error") {
                        expect(sut.isModelValid()).toNot(beNil())
                    }
                }
                
                context("when start date is earlier that today") {
                    
                    beforeEach {
                        sut.startDateItem.date = NSDate(timeIntervalSince1970: 1000)
                    }
                    
                    it("should return validation error") {
                        expect(sut.isModelValid()).toNot(beNil())
                    }
                }
                
                context("when end date is earlier than start date") {
                    
                    beforeEach {
                        sut.startDateItem.date = NSDate(timeIntervalSinceNow: 1000)
                        sut.endDateItem.date = NSDate()
                    }
                    
                    it("should return validation error") {
                        expect(sut.isModelValid()).toNot(beNil())
                    }
                }
                
                context("when minimum event duration is set to 60 minutes") {
                    
                    beforeEach {
                        var configuration = self.timelineConfiguration()
                        configuration.minimumEventDuration = 60*60
                        sut.timelineConfiguration = configuration
                    }
                    
                    context("and event takes only 10 minutes") {
                        
                        beforeEach {
                            sut.endDateItem.date = NSDate(timeIntervalSinceNow: 60*10)
                        }
                        
                        it("should return validation error") {
                            expect(sut.isModelValid()).toNot(beNil())
                        }
                    }
                }
                
                context("when user didn't choose room") {
                    
                    beforeEach {
                        sut.calendarItem.result = nil
                    }
                    
                    it("should return validation error") {
                        expect(sut.isModelValid()).toNot(beNil())
                    }
                }
            }
        }
        
        describe("initializing without calendar entry") {
                        
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
    
    func timelineConfiguration() -> TimelineConfiguration {
        
        var configuration = TimelineConfiguration()
        configuration.minimumEventDuration = 60*15
        configuration.defaultEventDuration = 60*30
        configuration.timeStep = 60*30
        configuration.bookingRange = (0, 60*60*23 + 59) // 0.00 AM to 11:59 PM
        configuration.bookingDays = [1, 2, 3, 4, 5, 6, 7]
        configuration.bookablePast = false
        
        return configuration
    }
    
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
