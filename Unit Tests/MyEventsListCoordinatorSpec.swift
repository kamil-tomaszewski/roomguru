//
//  MyEventsListCoordinatorSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

class MyEventsListCoordinatorSpec: QuickSpec {
    
    override func spec() {
        
        var sut: MyEventsListCoordinator!
        
        describe("when newly initialized") {
            
            beforeEach {
                sut = MyEventsListCoordinator(date: NSDate(timeIntervalSinceReferenceDate: 1000), calendarIDs: ["Fixture Calendar ID.1", "Fixture Calendar ID.2"])
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
        
        describe("when requesting for data") {
            
            context("and there are no calendar entries") {
                
                class MockEventsProvider: EventsProvider {
                    override func userActiveCalendarEntriesWithCompletion(completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
                        completion(calendarEntries: [], error: nil)
                    }
                }
                
                sut = MyEventsListCoordinator(date: NSDate(), calendarIDs: [])
                let mockEventsProvider = MockEventsProvider(calendarIDs: sut.eventsProvider.calendarIDs, timeRange: sut.date.dayTimeRange)
                sut.eventsProvider = mockEventsProvider
                
                itBehavesLike("events coordinator") {
                    [
                        "status" : "Empty",
                        "message" : [
                            "value" : "You haven't got any meetings this day.\n\nFinally peace and quiet.",
                            "isNil" : false
                        ],
                        "icon" : [
                            "value" : String.fontAwesomeIconWithName(FontAwesome.SmileO),
                            "isNil" : false
                        ],
                        "sut": sut
                    ]
                }
            }
            
            context("and there are calendar entries") {
                
                class MockEventsProvider: EventsProvider {
                    override func userActiveCalendarEntriesWithCompletion(completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
                        
                        let calendarEntry = CalendarEntry(calendarID: "Fixture Calendar ID", event: Event())
                        completion(calendarEntries: [calendarEntry], error: nil)
                    }
                }
                
                sut = MyEventsListCoordinator(date: NSDate(), calendarIDs: [])
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
            
            context("and an error occured") {
                
                class MockEventsProvider: EventsProvider {
                    
                    override func userActiveCalendarEntriesWithCompletion(completion: (calendarEntries: [CalendarEntry], error: NSError?) -> Void) {
                        
                        let error = NSError(message: "Fixture Error Message")
                        completion(calendarEntries: [], error: error)
                    }
                }
                
                sut = MyEventsListCoordinator(date: NSDate(), calendarIDs: [])
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
}
