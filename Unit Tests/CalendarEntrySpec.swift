//
//  CalendarEntrySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 10.06.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON


class CalendarEntrySpec: QuickSpec {
    
    override func spec() {
        
        let fixtureCalendarID = "FixtureCalendarID"
    
        let mockEventFirst = self.mockedEvent("FirstFixtureID", startDate: "2015-04-24T01:00:00-07:00", endDate: "2015-04-24T01:30:00-07:00")
        let mockEventSecond = self.mockedEvent("SecondFixtureID", startDate: "2015-08-24T01:00:00-07:00", endDate: "2015-08-24T01:30:00-07:00")
        let mockEventThird = self.mockedEvent("ThirdFixtureID", startDate: "2015-06-24T01:00:00-07:00", endDate: "2015-06-24T01:30:00-07:00")
        
        let mockEvents = [mockEventFirst, mockEventSecond, mockEventThird]
        
        it("should support secure coding") {
            expect(CalendarEntry.supportsSecureCoding()).to(beTrue())
        }
        
        
        describe("When initialized") {
           
            var sut: CalendarEntry!
            
            beforeEach {
                sut = CalendarEntry(calendarID: fixtureCalendarID, event: mockEventFirst)
            }
            
            afterEach {
                sut = nil
            }
            
            it("should have proper calendar ID") {
                expect(sut.calendarID).to(equal(fixtureCalendarID))
            }
            
            it("should have proper event") {
                expect(sut.event).to(equal(mockEventFirst))
            }
            
            context("archiving and unarchiving") {
                
                it("should have the same calendarID after archiving and unarchiving") {
                    let archivedCalendarEntry = NSKeyedArchiver.archivedDataWithRootObject(sut)
                    let unarchivedCalendarEntry = NSKeyedUnarchiver.unarchiveObjectWithData(archivedCalendarEntry) as! CalendarEntry
                    expect(sut.calendarID).to(equal(unarchivedCalendarEntry.calendarID))
                }
                
                it("should have the same event identifier after archiving and unarchiving") {
                    let archivedCalendarEntry = NSKeyedArchiver.archivedDataWithRootObject(sut)
                    let unarchivedCalendarEntry = NSKeyedUnarchiver.unarchiveObjectWithData(archivedCalendarEntry) as! CalendarEntry
                    expect(sut.event.identifier).to(equal(unarchivedCalendarEntry.event.identifier))
                }
            }
        }
        
        describe("When creating calendar entries array") {
            
            let mockCalendarEntries = self.mockedCalendarEntries(fixtureCalendarID, events: mockEvents)
            var sut = CalendarEntry.caledarEntries(fixtureCalendarID, events: mockEvents)
            
            it("should have proper number of calendar entries") {
                expect(sut.count).to(equal(mockCalendarEntries.count))
            }
            
            context("every calendar entry from array") {
                
                for index in 0..<sut.count {
                
                    let calendarEntry = sut[index]
                    let mockCalendarEntry = mockCalendarEntries[index]
                
                    it("should have proper Calendar ID") {
                        expect(calendarEntry.calendarID).to(equal(mockCalendarEntry.calendarID))
                    }
                
                    it("should have proper event") {
                        expect(calendarEntry.event).to(equal(mockCalendarEntry.event))
                    }
                }
            }
        }
        
        describe("When sorting calendar entries by date") {
            
            let unsortedEntries = CalendarEntry.caledarEntries(fixtureCalendarID, events: mockEvents)
            let sortedEntries = unsortedEntries.sorted { $0.event.start.compare($1.event.start).ascending }
            var sut = CalendarEntry.sortedByDate(unsortedEntries)
            
            it("should be sorted ascendingly") {
                expect(sut).to(equal(sortedEntries))
            }
        }
    }
}

private extension CalendarEntrySpec {
    
    func mockedEvent(eventID: String, startDate: String, endDate: String) -> Event {
        
        return Event(json: JSON([
            "id" : eventID,
            "summary" : "Fixture summary",
            "status" : "confirmed",
            "htmlLink" : "",
            "start" : ["dateTime" : startDate],
            "end" : ["dateTime" : endDate],
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
    
    func mockedCalendarEntries(calendarID: String, events: [Event]) -> [CalendarEntry] {
        var entries: [CalendarEntry] = []
        for event in events {
            let entry = CalendarEntry(calendarID: calendarID, event: event)
            entries.append(entry)
        }
        return entries
    }
}
