//
//  FreeEventsProviderSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 05/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

class FreeEventsProviderSpec: QuickSpec {
    
    override func spec() {
        
        var sut: FreeEventsProvider!
        var timeRange: TimeRange!
        var calendarEntries: [CalendarEntry]!
        var calendarIDs: [String]!
        
        beforeEach {
            sut = FreeEventsProvider()
        }
        
        describe("when newly initialized") {
            
            it("should have configuration set") {
                expect(sut.configuration).toNot(beNil())
            }
        }
        
        describe("when populates empty calendar entries") {
            
            beforeEach {
                calendarEntries = []
            }
            
            describe("with single calendar ID") {
                
                beforeEach {
                    calendarIDs = ["Fixture Calendar ID"]
                }
                
                context("in the past") {
                    
                    beforeEach { //get round date in the past:
                        timeRange = self.timeRange(fromDate: NSDate(timeIntervalSinceReferenceDate: 60*60*10), duration: 60*60)
                    }
                    
                    context("when booking in the past is not allowed") {
                        
                        beforeEach {
                            sut.configuration = self.timelineConfiguration()
                        }

                        it("should return 0 calendar entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(0))
                        }
                    }
                    
                    context("when booking in the past is allowed") {

                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.bookablePast = true
                            sut.configuration = configuration
                        }

                        it("should return 2 entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(2))
                        }
                        
                        it("should have exactly 2 free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(2))
                        }
                    }
                }
                
                context("in the future") {

                    beforeEach { //get round date in the future:
                        timeRange = self.timeRange(fromDate: NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30), duration: 60*60)
                    }

                    context("when booking wih default configuration") {

                        beforeEach {
                            sut.configuration = self.timelineConfiguration()
                        }

                        it("should return empty result") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(2))
                        }
                    }

                    context("when time step is set to 15 minutes") {

                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.timeStep = 60*15
                            sut.configuration = configuration
                        }

                        it("should return 4 entries") { // 60 minutes time available / 15 minutes every event = 4 entries
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(4))
                        }
                        
                        it("should have exactly 4 free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(4))
                        }
                    }

                    context("when minimum event duration is set to 60 minutes") {

                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.minimumEventDuration = 60*60
                            sut.configuration = configuration
                        }

                        context("and time step is set to 60 minutes as well") {

                            beforeEach {
                                var configuration = sut.configuration
                                configuration.timeStep = 60*60
                                sut.configuration = configuration
                            }

                            it("should return 1 entry") {
                                let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                                expect(calendarEntries.count).to(equal(1))
                            }
                        }

                        context("and time step is lower than 60 minutes") {

                            beforeEach {
                                var configuration = sut.configuration
                                configuration.timeStep = 60*59
                                sut.configuration = configuration
                            }

                            it("should return 0 entries") {
                                let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                                expect(calendarEntries.count).to(equal(0))
                            }
                        }
                    }

                    context("when booking in Wednesday is disabled") {

                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.bookingDays = [1, 2, 3, 5, 6, 7] // exclude Wednesday: NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30) is 4 day of week
                            sut.configuration = configuration
                        }

                        it("should return 0 entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(0))
                        }
                    }

                    context("when booking earlier than allowed") {

                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.bookingRange = (60*60*10, 60*60*15) // 10.00 AM to 15:00 AM
                            sut.configuration = configuration
                        }

                        it("should return 0 entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(0))
                        }
                    }

                    context("when booking later than allowed") {

                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.bookingRange = (60*60*10, 60*60*15) // 10.00 AM to 15:00 AM
                            sut.configuration = configuration

                            let date = NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30 + 60*60*16) // round date + 16 hours
                            timeRange = self.timeRange(fromDate: date, duration: 60*60)
                        }

                        it("should return 0 entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(0))
                        }
                    }
                }
            }
        }
        
        describe("when populates calendar entries") {

            describe("with same calendar ID") {

                beforeEach {
                    calendarIDs = ["Fixture Calendar"]
                }

                describe("in the past") {

                    beforeEach {
                        timeRange = self.timeRange(fromDate: NSDate(timeIntervalSinceReferenceDate: 60*60*10), duration: 60*60*6)

                        let start1 = NSDate(timeIntervalSinceReferenceDate: 60*60*10) //+10h
                        let start2 = NSDate(timeIntervalSinceReferenceDate: 60*60*10.5) //+10.5h
                        let start3 = NSDate(timeIntervalSinceReferenceDate: 60*60*12) //+12h

                        calendarEntries = [
                            self.mockCalendarEntryWithCalendarID("Fixture Calendar", start: start1, duration:60*30),
                            self.mockCalendarEntryWithCalendarID("Fixture Calendar", start: start2, duration:60*30),
                            self.mockCalendarEntryWithCalendarID("Fixture Calendar", start: start3, duration:60*30)
                        ]
                    }

                    context("when booking wih default configuration") {

                        beforeEach {
                            sut.configuration = self.timelineConfiguration()
                        }

                        it("should return 3 calendar entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(3))
                        }
                        
                        it("should have no free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(0))
                        }
                    }

                    context("when booking in the past is allowed") {

                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.bookablePast = true
                            sut.configuration = configuration
                        }

                        it("should return 12 entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(12))
                        }

                        it("should have exactly 9 free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(9))
                        }
                    }
                }

                describe("in the future") {

                    beforeEach {
                        let date = NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30 + 60*60*10) //+10h
                        timeRange = self.timeRange(fromDate: date, duration: 60*60*4)

                        let start1 = NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30 + 60*60*10) //+10h
                        let start2 = NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30 + 60*60*10.5) //+10.5h
                        let start3 = NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30 + 60*60*12) //+12h

                        calendarEntries = [
                            self.mockCalendarEntryWithCalendarID("Fixture Calendar", start: start1, duration:60*30),
                            self.mockCalendarEntryWithCalendarID("Fixture Calendar", start: start2, duration:60*30),
                            self.mockCalendarEntryWithCalendarID("Fixture Calendar", start: start3, duration:60*30)
                        ]
                    }

                    context("when booking wih default configuration") {

                        beforeEach {
                            sut.configuration = self.timelineConfiguration()
                        }

                        it("should return 8 calendar entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(8))
                        }

                        it("should have exactly 5 free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(5))
                        }
                    }

                    context("when time step is set to 15 minutes") {

                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.timeStep = 60*15
                            sut.configuration = configuration
                        }

                        it("should return 13 calendar entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(13))
                        }

                        it("should have exactly 10 free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(10))
                        }
                    }

                    context("when minimum event duration is set to 1 hour") {

                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.minimumEventDuration = 60*60
                            sut.configuration = configuration
                        }

                        it("should return 3 calendar entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(3))
                        }

                        it("should not have free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(0))
                        }
                    }

                    context("when booking earlier than allowed") {
                        
                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.bookingRange = (60*60*15, 60*60*20) // 3.00 PM to 8:00 PM
                            sut.configuration = configuration
                        }
                        
                        it("should return 3 entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(3))
                        }
                        
                        it("should not have free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(0))
                        }
                    }
                    
                    context("when booking later than allowed") {
                        
                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.bookingRange = (60*60*10, 60*60*15) // 10.00 AM to 15:00 AM
                            sut.configuration = configuration
                            
                            let date = NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30 + 60*60*16) // round date + 16 hours
                            timeRange = self.timeRange(fromDate: date, duration: 60*60)
                        }
                        
                        it("should return 3 entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(3))
                        }
                        
                        it("should have no free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(0))
                        }
                    }
                    
                    context("when booking in Wednesday is disabled") {
                        
                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.bookingDays = [1, 2, 3, 5, 6, 7] // exclude Wednesday: NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30) is 4 day of week
                            sut.configuration = configuration
                        }
                        
                        it("should return 3 entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(3))
                        }
                    }
                }
            }
            
            describe("with various calendar IDs") {
                
                beforeEach {
                    calendarIDs = ["Fixture Calendar ID.1", "Fixture Calendar ID.2"]
                }
                
                describe("in the past") {
                    
                    beforeEach {
                        timeRange = self.timeRange(fromDate: NSDate(timeIntervalSinceReferenceDate: 60*60*10), duration: 60*60*6)
                        
                        let start1 = NSDate(timeIntervalSinceReferenceDate: 60*60*10) //+10h
                        let start2 = NSDate(timeIntervalSinceReferenceDate: 60*60*10.5) //+10.5h
                        let start3 = NSDate(timeIntervalSinceReferenceDate: 60*60*12) //+12h
                        
                        calendarEntries = [
                            self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.1", start: start1, duration:60*30),
                            self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.1", start: start2, duration:60*30),
                            self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.2", start: start3, duration:60*30)
                        ]
                    }
                    
                    context("when booking wih default configuration") {
                        
                        beforeEach {
                            sut.configuration = self.timelineConfiguration()
                        }
                        
                        it("should return 3 calendar entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(3))
                        }
                        
                        it("should have no free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(0))
                        }
                    }
                    
                    context("when booking in the past is allowed") {
                        
                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.bookablePast = true
                            sut.configuration = configuration
                        }
                        
                        it("should return 24 entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(24))
                        }
                        
                        it("should have exactly 9 free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(21))
                        }
                    }
                }
                
                describe("in the future") {
                    
                    beforeEach {
                        let date = NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30 + 60*60*10) //+10h
                        timeRange = self.timeRange(fromDate: date, duration: 60*60*4)
                        
                        let start1 = NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30 + 60*60*10) //+10h
                        let start2 = NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30 + 60*60*10.5) //+10.5h
                        let start3 = NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30 + 60*60*12) //+12h
                        
                        calendarEntries = [
                            self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.1", start: start1, duration:60*30),
                            self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.1", start: start2, duration:60*30),
                            self.mockCalendarEntryWithCalendarID("Fixture Calendar ID.2", start: start3, duration:60*30)
                        ]
                    }
                    
                    context("when booking wih default configuration") {
                        
                        beforeEach {
                            sut.configuration = self.timelineConfiguration()
                        }
                        
                        it("should return 16 calendar entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(16))
                        }
                        
                        it("should have exactly 13 free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(13))
                        }
                    }
                    
                    context("when time step is set to 15 minutes") {
                        
                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.timeStep = 60*15
                            sut.configuration = configuration
                        }
                        
                        it("should return 29 calendar entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(29))
                        }
                        
                        it("should have exactly 26 free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(26))
                        }
                    }

                    context("when minimum event duration is set to 1 hour") {
                        
                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.minimumEventDuration = 60*60
                            sut.configuration = configuration
                        }
                        
                        it("should return 3 calendar entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(3))
                        }
                        
                        it("should not have free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(0))
                        }
                    }

                    context("when booking earlier than allowed") {
                        
                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.bookingRange = (60*60*15, 60*60*20) // 3.00 PM to 8:00 PM
                            sut.configuration = configuration
                        }
                        
                        it("should return 3 entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(3))
                        }
                        
                        it("should not have free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(0))
                        }
                    }

                    context("when booking later than allowed") {
                        
                        beforeEach {
                            var configuration = self.timelineConfiguration()
                            configuration.bookingRange = (60*60*10, 60*60*15) // 10.00 AM to 15:00 AM
                            sut.configuration = configuration
                            
                            let date = NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30 + 60*60*16) // round date + 16 hours
                            timeRange = self.timeRange(fromDate: date, duration: 60*60)
                        }
                        
                        it("should return 3 entries") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.count).to(equal(3))
                        }
                        
                        it("should have no free events") {
                            let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                            expect(calendarEntries.filter { $0.event is FreeEvent }.count).to(equal(0))
                        }
                    }
                }
                
                context("when booking in Wednesday is disabled") {
                    
                    beforeEach {
                        var configuration = self.timelineConfiguration()
                        configuration.bookingDays = [1, 2, 3, 5, 6, 7] // exclude Wednesday: NSDate(timeIntervalSinceReferenceDate: 60*60*24*365*30) is 4 day of week
                        sut.configuration = configuration
                    }
                    
                    it("should return 3 entries") {
                        let calendarEntries = sut.populateEntriesWithFreeEvents(calendarEntries, inTimeRange: timeRange, usingCalenadIDs: calendarIDs)
                        expect(calendarEntries.count).to(equal(3))
                    }
                }
            }
        }
    }
}

private extension FreeEventsProviderSpec {
    
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
    
    func mockCalendarEntryWithCalendarID(calendarID: String, start: NSDate, duration: NSTimeInterval) -> CalendarEntry {
        var event = Event()
        event.start = start
        event.end =  NSDate(timeInterval: duration, sinceDate: start)
        return CalendarEntry(calendarID: calendarID, event: event)
    }
    
    func timeRange(fromDate date: NSDate, duration: Int) -> TimeRange {
        let startDate = NSDate(timeIntervalSinceReferenceDate: 60*60*10)
        let endDate = NSDate(timeInterval: NSTimeInterval(duration), sinceDate: date)
        return TimeRange(min: date, max: endDate)
    }
}
