//
//  EventsProviderSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 10/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON

class EventsProviderSpec: QuickSpec {
    
    override func spec() {
        
        var timeRangeZero: TimeRange { return self.timeRange(fromDate: NSDate(timeIntervalSinceReferenceDate: 0), duration: 0) }
        
        var sut: EventsProvider!
        var returnedError: NSError?
        var entries: [CalendarEntry]!
        
        beforeEach {
            sut = EventsProvider(calendarIDs: ["Fixture Calendar ID"], timeRange: timeRangeZero)
            sut.freeEventsProvider = MockFreeEventsProvider()
        }
        
        afterEach {
            sut = nil
            returnedError = nil
            entries = nil
        }
        
        describe("when newly initialized") {
            
            it("should have properly set calendar IDs") {
                expect(sut.calendarIDs).to(contain("Fixture Calendar ID"))
            }
            
            it("should have network cooperator") {
                expect(sut.networkCooperator).toNot(beNil())
            }
        }
        
        describe("when request about active entries") {

            context("and there is no entries at all") {
                
                beforeEach {
                    sut.networkCooperator = MockEventsProviderNetworkCooperator(result: [], error: nil)
                }
                
                it("error should be nil.") {
                    
                    waitUntil { done in
                        sut.activeCalendarEntriesWithCompletion { (calendarEntries, error) in
                            returnedError = error
                            done()
                        }
                    }
                    
                    expect(returnedError).to(beNil())
                }
                
                it("should return empty entries.") {
                    
                    waitUntil { done in
                        sut.activeCalendarEntriesWithCompletion { (calendarEntries, error) in
                            entries = calendarEntries
                            done()
                        }
                    }
                    
                    expect(entries.count).to(equal(0))
                }
            }
            
            context("and provider return result") {
                
                beforeEach {
                    sut.networkCooperator = MockEventsProviderNetworkCooperator(result: self.mockedResult(), error: nil)
                }
                
                it("error should not be nil.") {
                    
                    waitUntil { done in
                        sut.activeCalendarEntriesWithCompletion { (calendarEntries, error) in
                            returnedError = error
                            done()
                        }
                    }
                    
                    expect(returnedError).to(beNil())
                }
                
                it("should return 3 entries.") {
                    
                    waitUntil { done in
                        sut.activeCalendarEntriesWithCompletion { (calendarEntries, error) in
                            entries = calendarEntries
                            done()
                        }
                    }
                    
                    expect(entries.count).to(equal(3))
                }
            }
            
            context("and an error did appear") {
                
                beforeEach {
                    let error = NSError(message: "Fixture Error Message")
                    sut.networkCooperator = MockEventsProviderNetworkCooperator(result: [], error: error)
                }
                
                it("error should not be nil.") {
                    
                    waitUntil { done in
                        sut.activeCalendarEntriesWithCompletion { (calendarEntries, error) in
                            returnedError = error
                            done()
                        }
                    }
                    
                    expect(returnedError).toNot(beNil())
                }
                
                it("error should contain proper message.") {
                    
                    waitUntil { done in
                        sut.activeCalendarEntriesWithCompletion { (calendarEntries, error) in
                            returnedError = error
                            done()
                        }
                    }
                    
                    expect(returnedError?.localizedDescription).to(equal("Fixture Error Message"))
                }
                
                it("returned entries should be empty.") {
                    
                    waitUntil { done in
                        sut.activeCalendarEntriesWithCompletion { (calendarEntries, error) in
                            entries = calendarEntries
                            done()
                        }
                    }
                    
                    expect(entries.count).to(equal(0))
                }
            }
        }
        
        describe("when request about user active entries") {
            
            context("and there is no entries at all") {
                
                beforeEach {
                    sut.networkCooperator = MockEventsProviderNetworkCooperator(result: [], error: nil)
                }
                
                it("error should be nil.") {
                    
                    waitUntil { done in
                        sut.userActiveCalendarEntriesWithCompletion { (calendarEntries, error) in
                            returnedError = error
                            done()
                        }
                    }
                    
                    expect(returnedError).to(beNil())
                }
                
                it("should return empty entries.") {
                    
                    waitUntil { done in
                        sut.userActiveCalendarEntriesWithCompletion { (calendarEntries, error) in
                            entries = calendarEntries
                            done()
                        }
                    }
                    
                    expect(entries.count).to(equal(0))
                }
            }
            
            context("and provider return result") {
                
                beforeEach {
                    sut.networkCooperator = MockEventsProviderNetworkCooperator(result: self.mockedResult(), error: nil)
                }
                
                it("error should not be nil.") {
                    
                    waitUntil { done in
                        sut.userActiveCalendarEntriesWithCompletion { (calendarEntries, error) in
                            returnedError = error
                            done()
                        }
                    }
                    
                    expect(returnedError).to(beNil())
                }
                
                describe("when registered user is creator") {
                    
                    beforeEach {
                        UserPersistenceStore.sharedStore.registerUserWithEmail("FixtureCreatorEmail")
                    }
                    
                    afterEach {
                        UserPersistenceStore.sharedStore.clear()
                    }
                    
                    it("should return 1 entry.") {
                        
                        waitUntil { done in
                            sut.userActiveCalendarEntriesWithCompletion { (calendarEntries, error) in
                                entries = calendarEntries
                                done()
                            }
                        }
                        
                        expect(entries.count).to(equal(1))
                    }
                }
                
                describe("when registered user is attendee") {
                    
                    beforeEach {
                        UserPersistenceStore.sharedStore.registerUserWithEmail("FixtureAttendeeEmail")
                    }
                    
                    afterEach {
                        UserPersistenceStore.sharedStore.clear()
                    }
                    
                    it("should return 1 entry.") {
                        
                        waitUntil { done in
                            sut.userActiveCalendarEntriesWithCompletion { (calendarEntries, error) in
                                entries = calendarEntries
                                done()
                            }
                        }
                        
                        expect(entries.count).to(equal(1))
                    }
                }
                
                describe("when registered user is not creator nor attendee") {
                    
                    beforeEach {
                        UserPersistenceStore.sharedStore.registerUserWithEmail("AnyFixtureEmail")
                    }
                    
                    afterEach {
                        UserPersistenceStore.sharedStore.clear()
                    }
                    
                    it("should return 0 entries") {
                        
                        waitUntil { done in
                            sut.userActiveCalendarEntriesWithCompletion { (calendarEntries, error) in
                                entries = calendarEntries
                                done()
                            }
                        }
                        
                        expect(entries.count).to(equal(0))
                    }
                }
            }

            context("and an error did appear") {
                
                beforeEach {
                    let error = NSError(message: "Fixture Error Message")
                    sut.networkCooperator = MockEventsProviderNetworkCooperator(result: [], error: error)
                }
                
                it("error should not be nil.") {
                    
                    waitUntil { done in
                        sut.userActiveCalendarEntriesWithCompletion { (calendarEntries, error) in
                            returnedError = error
                            done()
                        }
                    }
                    
                    expect(returnedError).toNot(beNil())
                }
                
                it("error should contain proper message.") {
                    
                    waitUntil { done in
                        sut.userActiveCalendarEntriesWithCompletion { (calendarEntries, error) in
                            returnedError = error
                            done()
                        }
                    }
                    
                    expect(returnedError?.localizedDescription).to(equal("Fixture Error Message"))
                }
                
                it("returned entries should be empty.") {
                    
                    waitUntil { done in
                        sut.userActiveCalendarEntriesWithCompletion { (calendarEntries, error) in
                            entries = calendarEntries
                            done()
                        }
                    }
                    
                    expect(entries.count).to(equal(0))
                }
            }
        }
    }
}

private extension EventsProviderSpec {
    
    class MockFreeEventsProvider : FreeEventsProvider {
        override func populateEntriesWithFreeEvents(entriesToFill: [CalendarEntry], inTimeRange timeRange: TimeRange, usingCalenadIDs calendarIDs: [String]) -> [CalendarEntry] {
            return entriesToFill // Do not fill entries with free events. Those tests are parts of FreeEventsProviderSpec.
        }
    }
    
    func timeRange(fromDate date: NSDate, duration: Int) -> TimeRange {
        let startDate = NSDate(timeIntervalSinceReferenceDate: 60*60*10)
        let endDate = NSDate(timeInterval: NSTimeInterval(duration), sinceDate: date)
        return TimeRange(min: date, max: endDate)
    }
    
    func mockedResult() -> [CalendarEntry] {
        return [
            CalendarEntry(calendarID: "Fixture Calendar ID", event: mockedEvent(status: .Confirmed, roomStatus: .Going, isCreator: false, isAttendee: false)),
            CalendarEntry(calendarID: "Fixture Calendar ID", event: mockedEvent(status: .Tentative, roomStatus: .Going, isCreator: true, isAttendee: false)),
            CalendarEntry(calendarID: "Fixture Calendar ID", event: mockedEvent(status: .Cancelled, roomStatus: .Going, isCreator: false, isAttendee: true)),
            CalendarEntry(calendarID: "Fixture Calendar ID", event: mockedEvent(status: .Cancelled, roomStatus: .NotGoing, isCreator: false, isAttendee: false))
        ]
    }
    
    func mockedEvent(#status: EventStatus, roomStatus: Status, isCreator: Bool, isAttendee: Bool) -> Event {
        
        return Event(json: JSON([
            "id" : "Fixture Event ID",
            "summary" : "Fixture Summary",
            "status" : status.rawValue,
            "htmlLink" : "",
            "start" : ["dateTime" : "2015-04-24T01:00:00-07:00"],
            "end" : ["dateTime" : "2015-04-24T01:01:00-07:00"],
            "attendees" : [
                mockedAttendeeJSONWithName("FixtureName.1", email: isAttendee ? "FixtureAttendeeEmail" : "FixtureEmail.1", status: .Going),
                mockedAttendeeJSONWithName("FixtureName.2", email: isAttendee ? "FixtureAttendeeEmail" : "FixtureEmail.2", status: .NotGoing),
                mockedAttendeeJSONWithName("FixtureName.3", email: isAttendee ? "FixtureAttendeeEmail" : "FixtureEmail.3", status: .Maybe),
                mockedRoomJSONWithName("FixtureRoom.1", email: "FixtureRoomEmail.1", status: roomStatus),
            ],
            "creator" : mockedAttendeeJSONWithName("FixtureName.4", email: isCreator ? "FixtureCreatorEmail": "FixtureEmail.4", status: .Going)
        ]))
    }
    
    func mockedAttendeeJSONWithName(name: String, email: String, status: Status) -> [String : String] {
        return [
            "email" : email,
            "responseStatus" : status.rawValue,
            "displayName" : name
        ]
    }
    
    func mockedRoomJSONWithName(name: String, email: String, status: Status) -> [String : String] {
        return [
            "email" : email,
            "responseStatus" : status.rawValue,
            "displayName" : name,
            "self" : String(stringInterpolationSegment: true),
            "resource" : String(stringInterpolationSegment: true)
        ]
    }
}

private class MockEventsProviderNetworkCooperator: EventsProviderNetworkCooperator {
    
    let result: [CalendarEntry]?
    let error: NSError?
    
    init(result: [CalendarEntry], error: NSError?) {
        self.result = result
        self.error = error
    }
    
    override func entriesWithCalendarIDs(calendarIDs: [String], timeRange: TimeRange, completion: (result: [CalendarEntry]?, error: NSError?) -> Void) {
        completion(result: result, error: error)
    }
}
