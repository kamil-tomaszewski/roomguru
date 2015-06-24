//
//  BookingManagerSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 23/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick
import SwiftyJSON

class BookingManagerSpec: QuickSpec {
    override func spec() {
        
        var sut: BookingManager!
        
        describe("when booking calendar entry") {
            
            var anEvent: Event?
            var anError: NSError?
            
            afterEach {
                sut = nil
                anEvent = nil
                anError = nil
            }
            
            describe("and an error did appear in network call") {
                
                class MockNetworkManager: NetworkManager {
                    override func request(query: Query, success: ResponseBlock, failure: ErrorBlock) {
                        failure(error: NSError(message: "Fixture Error Message"))
                    }
                }
                
                beforeEach {
                    sut = BookingManager(usingMockNetworkManager: MockNetworkManager())
                    
                    let start1 = NSDate(timeIntervalSinceReferenceDate: 60*60*12) //+12h
                    let entry = self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.2", start: start1, duration: 60*30, free: false)
                    sut.bookCalendarEntry(entry) { (event, error) in
                        anEvent = event
                        anError = error
                    }
                }
                
                it("event should be nil") {
                    expect(anEvent).to(beNil())
                }
                
                it("error should be not nil") {
                    expect(anError).toNot(beNil())
                }
                
                it("error should have appropriate message") {
                    expect(anError!.localizedDescription).to(equal("Fixture Error Message"))
                }
            }
            
            describe("and server returns empty response") {
                
                class MockNetworkManager: NetworkManager {
                    override func request(query: Query, success: ResponseBlock, failure: ErrorBlock) {
                        success(response: nil)
                    }
                }
                
                beforeEach {
                    sut = BookingManager(usingMockNetworkManager: MockNetworkManager())
                    
                    let start1 = NSDate(timeIntervalSinceReferenceDate: 60*60*12) //+12h
                    let entry = self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.2", start: start1, duration: 60*30, free: false)
                    sut.bookCalendarEntry(entry) { (event, error) in
                        anEvent = event
                        anError = error
                    }
                }
                
                it("event should be nil") {
                    expect(anEvent).to(beNil())
                }
                
                it("error should be not nil") {
                    expect(anError).toNot(beNil())
                }
            }
            
            describe("and server returns result") {
                
                class MockNetworkManager: NetworkManager {
                    override func request(query: Query, success: ResponseBlock, failure: ErrorBlock) {
                        let json = [
                            "id" : "Fixture Event ID",
                            "start" : ["dateTime" : "2015-04-24T01:00:00-07:00", "timeZone" : "Europe/Warsaw"],
                            "end" : ["dateTime" : "2015-04-24T01:01:00-07:00", "timeZone" : "Europe/Warsaw"],
                            "attendees" : [[
                                "email" : "Fixture Email Address",
                                "responseStatus" : "accepted",
                                "displayName" : "Fixture Display Name",
                                "organizer" : "true"
                            ]],
                            "creator" : [
                                "email" : "Fixture Email Address",
                                "responseStatus" : "accepted",
                                "displayName" : "Fixture Display Name",
                                "self" : "true"
                            ]
                        ]
                        success(response: JSON(json))
                    }
                }
                
                beforeEach {
                    sut = BookingManager(usingMockNetworkManager: MockNetworkManager())
                    
                    let start1 = NSDate(timeIntervalSinceReferenceDate: 60*60*12) //+12h
                    let entry = self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.2", start: start1, duration: 60*30, free: false)
                    sut.bookCalendarEntry(entry) { (event, error) in
                        anEvent = event
                        anError = error
                    }
                }
                
                it("event should not be nil") {
                    expect(anEvent).toNot(beNil())
                }
                
                it("event should have properly set identifier") {
                    expect(anEvent!.identifier).to(equal("Fixture Event ID"))
                }
                
                it("event should only one attendee") {
                    expect(anEvent!.attendees.count).to(equal(1))
                }
                
                it("event creator should be same as attendee") {
                    let attendee = anEvent!.attendees[0]
                    let creator = anEvent!.creator!
                    
                    expect(attendee.email).to(equal(creator.email))
                }
                
                it("error should be nil") {
                    expect(anError).to(beNil())
                }
            }
        }
        
        describe("when revoking event") {
            
            var aSuccess: Bool?
            var anError: NSError?
            
            beforeEach {
                aSuccess = nil
                anError = nil
            }
            
            describe("and an error did appear in network call") {
                
                class MockNetworkManager: NetworkManager {
                    override func request(query: Query, success: ResponseBlock, failure: ErrorBlock) {
                        failure(error: NSError(message: "Fixture Error Message"))
                    }
                }
                
                beforeEach {
                    sut = BookingManager(usingMockNetworkManager: MockNetworkManager())
                    sut.revokeEvent("Fixture Event ID", userEmail: "Fixture User Email") { (success, error) in
                        aSuccess = success
                        anError = error
                    }
                }
                
                it("success should be false") {
                    expect(aSuccess).to(beFalse())
                }
                
                it("error should be not nil") {
                    expect(anError).toNot(beNil())
                }
            }
            
            describe("and server returns result") {
                
                class MockNetworkManager: NetworkManager {
                    override func request(query: Query, success: ResponseBlock, failure: ErrorBlock) {
                        success(response: JSON([:]))
                    }
                }
                
                beforeEach {
                    sut = BookingManager(usingMockNetworkManager: MockNetworkManager())
                    sut.revokeEvent("Fixture Event ID", userEmail: "Fixture User Email") { (success, error) in
                        aSuccess = success
                        anError = error
                    }
                }
                
                it("success should be true") {
                    expect(aSuccess).to(beTrue())
                }
                
                it("error should be nil") {
                    expect(anError).to(beNil())
                }
            }
        }
        
        describe("when asking about all bookable events") {
            
            var calendarEntries: [CalendarEntry]?
            var anError: NSError?

            beforeEach {
                sut = BookingManager()
                anError = nil
                calendarEntries = nil
            }
            
            describe("and event provider returns empty result") {
                
                beforeEach {
                    sut.eventsProvider = MockEventsProvider(calendarEntries: [], error: nil)
                    
                    sut.bookableCalendarEntries(calendarIDs: []) { (entries, error) in
                        calendarEntries = entries
                        anError = error
                    }
                }
                
                afterEach {
                    sut.eventsProvider = nil
                }
                
                it("entries should be empty") {
                    expect(calendarEntries!.count).to(equal(0))
                }
                
                it("error should be nil") {
                    expect(anError).to(beNil())
                }
            }
            
            describe("and event provider returns result") {
                
                beforeEach {
                    let start1 = NSDate(timeIntervalSinceReferenceDate: 60*60*12) //+12h
                    let start2 = NSDate(timeIntervalSinceReferenceDate: 60*60*10) //+10h
                    
                    sut.eventsProvider = MockEventsProvider(calendarEntries: [
                        self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.1", start: start1, duration: 60*60, free: true),
                        self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.2", start: start2, duration: 60*60, free: true),
                        self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.2", start: start1, duration: 60*30, free: false)
                    ], error: nil)
                    
                    sut.bookableCalendarEntries(calendarIDs: ["Fixture Calendar ID.1", "Fixture Calendar ID.2"]) { (entries, error) in
                        calendarEntries = entries
                        anError = error
                    }
                }
                
                afterEach {
                    sut.eventsProvider = nil
                }
                
                it("entries should have 2 free events") {
                    expect(calendarEntries!.count).to(equal(2))
                }

                it("entries should be properly sorted") {
                    let mapCalendarIDs = calendarEntries!.map { $0.calendarID }
                    expect(mapCalendarIDs).to(equal(["Fixture Calendar ID.2", "Fixture Calendar ID.1"]))
                }
                
                it("error should be nil") {
                    expect(anError).to(beNil())
                }
            }
            
            describe("and event provider returns error") {

                beforeEach {
                    sut.eventsProvider = MockEventsProvider(calendarEntries: [], error: NSError(message: "Fixture error"))
                    
                    sut.bookableCalendarEntries(calendarIDs: []) { (entries, error) in
                        calendarEntries = entries
                        anError = error
                    }
                }
                
                afterEach {
                    sut.eventsProvider = nil
                }
                
                it("entries should be nil") {
                    expect(calendarEntries).to(beNil())
                }
                
                it("error should be not be nil") {
                    expect(anError).toNot(beNil())
                }
            }
        }
        
        describe("when asking about first bookable event") {
            
            var calendarEntry: CalendarEntry?
            var anError: NSError?
            
            beforeEach {
                sut = BookingManager()
                calendarEntry = nil
                anError = nil
            }
            
            afterEach {
                sut = nil
            }

            describe("and event provider returns empty result") {
                
                beforeEach {
                    sut.eventsProvider = MockEventsProvider(calendarEntries: [], error: nil)
                    
                    sut.firstBookableCalendarEntry(calendarIDs: []) { (entry, error) in
                        calendarEntry = entry
                        anError = error
                    }
                }
                
                afterEach {
                    sut.eventsProvider = nil
                }
                
                it("entries should be empty") {
                    expect(calendarEntry).to(beNil())
                }
                
                it("error should be nil") {
                    expect(anError).to(beNil())
                }
            }
            
            describe("and event provider returns empty result") {
                
                beforeEach {
                    let start1 = NSDate(timeIntervalSinceReferenceDate: 60*60*12) //+12h
                    let start2 = NSDate(timeIntervalSinceReferenceDate: 60*60*10) //+10h
                    
                    sut.eventsProvider = MockEventsProvider(calendarEntries: [
                        self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.1", start: start1, duration: 60*60, free: true),
                        self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.2", start: start2, duration: 60*60, free: true),
                        self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.2", start: start1, duration: 60*30, free: false),
                        ], error: nil)
                    
                    sut.firstBookableCalendarEntry(calendarIDs: ["Fixture Calendar ID.1", "Fixture Calendar ID.2"]) { (entry, error) in
                        calendarEntry = entry
                        anError = error
                    }
                }
                
                afterEach {
                    sut.eventsProvider = nil
                }
                
                it("entry should be properly returned") {
                    expect(calendarEntry!.calendarID).to(equal("Fixture Calendar ID.2"))
                }
                
                it("error should be nil") {
                    expect(anError).to(beNil())
                }
            }
            
            describe("and event provider returns error") {
                
                beforeEach {
                    sut.eventsProvider = MockEventsProvider(calendarEntries: [], error: NSError(message: "Fixture error"))
                    
                    sut.firstBookableCalendarEntry(calendarIDs: []) { (entry, error) in
                        calendarEntry = entry
                        anError = error
                    }
                }
                
                afterEach {
                    sut.eventsProvider = nil
                }
                
                it("entry should be nil") {
                    expect(calendarEntry).to(beNil())
                }
                
                it("error should be not be nil") {
                    expect(anError).toNot(beNil())
                }
            }
        }
    }
}

private extension BookingManager {
    
    convenience init(usingMockNetworkManager networkManager: NetworkManager) {
        self.init()
        self.networkManager = networkManager
    }
}

private extension BookingManagerSpec {
    
    func mockCalendarEntryWithCalendarID(calendarID: String, start: NSDate, duration: NSTimeInterval, free: Bool) -> CalendarEntry {
        var event: Event
        
        if free {
            event = FreeEvent(startDate: start, endDate: NSDate(timeInterval: duration, sinceDate: start))
        } else {
            event = Event()
            event.start = start
            event.end =  NSDate(timeInterval: duration, sinceDate: start)
        }
        
        return CalendarEntry(calendarID: calendarID, event: event)
    }
}

private class MockEventsProvider: EventsProvider {
    
    let calendarEntries: [CalendarEntry]?
    let error: NSError?
    
    init(calendarEntries: [CalendarEntry], error: NSError?) {
        self.calendarEntries = calendarEntries
        self.error = error
        super.init(calendarIDs: [], timeRange: (min: NSDate(), max: NSDate()))
    }
    override func activeCalendarEntriesWithCompletion(completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
        completion(calendarEntries: calendarEntries!, error: error)
    }
}
