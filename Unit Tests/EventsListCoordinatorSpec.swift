//
//  EventsListCoordinatorSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

class EventsListCoordinatorSpec: QuickSpec {
    
    override func spec() {
        
        var sut: EventsListCoordinator!
        
        describe("when newly initialized") {
            
            beforeEach {
                sut = EventsListCoordinator(date: NSDate(timeIntervalSinceReferenceDate: 1000), calendarIDs: ["Fixture Calendar ID.1", "Fixture Calendar ID.2"])
            }
            
            afterEach {
                sut = nil
            }
            
            it("should have properly set date") {
                expect(sut.date).to(equal(NSDate(timeIntervalSinceReferenceDate: 1000)))
            }
            
            it("should have properly set calendar IDs") {
                expect(sut.eventsProvider.calendarIDs).to(contain("Fixture Calendar ID.1", "Fixture Calendar ID.2"))
            }
        }
        
        describe("when requesting for data and there are no calendar entries") {
            
            class MockEventsProvider: EventsProvider {
                override func activeCalendarEntriesWithCompletion(completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
                    completion(calendarEntries: [], error: nil)
                }
            }
            
            sut = EventsListCoordinator(date: NSDate(), calendarIDs: [])
            let mockEventsProvider = MockEventsProvider(calendarIDs: sut.eventsProvider.calendarIDs, timeRange: sut.date.dayTimeRange)
            sut.eventsProvider = mockEventsProvider
            
            itBehavesLike("events coordinator") {
                [
                    "status" : "Empty",
                    "message" : [
                        "value" : "Weekend day.\nGo away and relax!",
                        "isNil" : false
                    ],
                    "icon" : [
                        "value" : String.fontAwesomeIconWithName(FontAwesome.CalendarO),
                        "isNil" : false
                    ],
                    "sut": sut
                ]
            }
        }
        
        describe("when requesting for data and there are calendar entries") {
            
            class MockEventsProvider: EventsProvider {
                override func activeCalendarEntriesWithCompletion(completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
                    
                    let event = Event()
                    let calendarEntry = CalendarEntry(calendarID: "Fixture Calendar ID", event: event)

                    completion(calendarEntries: [calendarEntry], error: nil)
                }
            }
            
            sut = EventsListCoordinator(date: NSDate(), calendarIDs: [])
            let mockEventsProvider = MockEventsProvider(calendarIDs: sut.eventsProvider.calendarIDs, timeRange: sut.date.dayTimeRange)
            sut.eventsProvider = mockEventsProvider
            
            itBehavesLike("events coordinator") {
                [
                    "status" : "Success",
                    "message" : [
                        "value" : "",
                        "isNil" : true
                    ],
                    "icon" : [
                        "value" : "",
                        "isNil" : true
                    ],
                    "sut": sut
                ]
            }
        }
        
        describe("when requesting for data and an error occured") {
            
            class MockEventsProvider: EventsProvider {
                
                override func activeCalendarEntriesWithCompletion(completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
                    
                    let error = NSError(message: "Fixture Error Message")
                    completion(calendarEntries: [], error: error)
                }
            }
            
            sut = EventsListCoordinator(date: NSDate(), calendarIDs: [])
            let mockEventsProvider = MockEventsProvider(calendarIDs: sut.eventsProvider.calendarIDs, timeRange: sut.date.dayTimeRange)
            sut.eventsProvider = mockEventsProvider
            
            itBehavesLike("events coordinator") {
                [
                    "status" : "Failed",
                    "message" : [
                        "value" : "Fixture Error Message",
                        "isNil" : false
                    ],
                    "icon" : [
                        "value" : String.fontAwesomeIconWithName(FontAwesome.MehO),
                        "isNil" : false
                    ],
                    "sut": sut
                ]
            }
        }
    }
}
