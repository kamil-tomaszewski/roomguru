//
//  EventsProviderSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 10/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

class EventsProviderSpec: QuickSpec {
    
    override func spec() {
        
        var sut: EventsProvider!
        
        
        describe("when newly initialized") {
            
            beforeEach {
                let timeRange = TimeRange(min: NSDate(), max: NSDate())
                sut = EventsProvider(calendarIDs: ["Fixture Calendar ID"], timeRange: timeRange)
            }
            
            afterEach {
                sut = nil
            }
            
            it("should have properly set calendar IDs") {
                expect(sut.calendarIDs).to(contain("Fixture Calendar ID"))
            }
            
            it("should have network cooperator") {
                expect(sut.networkCooperator).toNot(beNil())
            }
        }
        
        describe("when there is no entries at all") {
            
            var returnedError: NSError?
            var entries: [CalendarEntry]!
            
            class MockEventsProviderNetworkCooperator: EventsProviderNetworkCooperator {
                override func entriesWithCalendarIDs(calendarIDs: [String], timeRange: TimeRange, completion: (result: [CalendarEntry]?, error: NSError?) -> Void) {
                    completion(result: [], error: nil)
                }
            }
            
            beforeEach {
                let timeRange = TimeRange(min: NSDate(), max: NSDate())
                sut = EventsProvider(calendarIDs: [""], timeRange: timeRange)
                sut.networkCooperator = MockEventsProviderNetworkCooperator()
                
            }
            
            afterEach {
                sut = nil
                returnedError = nil
                entries = nil
            }
            
            it("should return") {
                
                waitUntil { done in
                   
                    sut.activeCalendarEntriesWithCompletion { (calendarEntries, error) in
                        returnedError = error
                        entries = calendarEntries
                        
                        done()
                    }
                }
                
                expect(returnedError).to(beNil())
                expect(entries.count).to(equal(0))
            }
        }
    }

}

private extension EventsProviderSpec {
    
    func timeRange(fromDate date: NSDate, duration: Int) -> TimeRange {
        let startDate = NSDate(timeIntervalSinceReferenceDate: 60*60*10)
        let endDate = NSDate(timeInterval: NSTimeInterval(duration), sinceDate: date)
        return TimeRange(min: date, max: endDate)
    }
}

