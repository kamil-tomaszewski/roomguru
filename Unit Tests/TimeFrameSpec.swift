//
//  TimeFrameSpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 27.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import DateKit

class TimeFrameSpec: QuickSpec {
    
    override func spec() {
        
        var sut: TimeFrame!
        
        let fixtureStartDate = NSDate().midnight
        let fixtureEndDate = NSDate().midnight.days + 1
        let fixtureDuration = fixtureEndDate.timeIntervalSinceDate(fixtureStartDate)
        
        describe("when initializing with start date, end date and availability") {
            
            let fixtureAvailability: TimeFrameAvailability = .Available
            
            beforeEach {
                sut = TimeFrame(startDate: fixtureStartDate, endDate: fixtureEndDate, availability: fixtureAvailability)
            }
            
            afterEach {
                sut = nil
            }
            
            it("shoud have proper start date") {
                expect(sut.startDate).to(equal(fixtureStartDate))
            }
            
            it("shoud have proper end date") {
                expect(sut.endDate).to(equal(fixtureEndDate))
            }
            
            it("shoud have proper availability") {
                expect(sut.availability.description ).to(equal(fixtureAvailability.description))
            }
            
            it("shoud have proper duration") {
                expect(sut.duration).to(equal(fixtureDuration))
            }
            
            it("shoud have proper description") {
                let fixtureDescription = self.fixtureDescription(fixtureStartDate, endDate: fixtureEndDate, duration: fixtureDuration, availability: fixtureAvailability)
                expect(sut.description).to(equal(fixtureDescription))
            }
        }
        
        describe("when initializing with start date and end date") {
            
            let fixtureAvailability: TimeFrameAvailability = .NotAvailable
            
            beforeEach {
               sut = TimeFrame(startDate: fixtureStartDate, endDate: fixtureEndDate)
            }
            
            afterEach {
                sut = nil
            }
            
            it("shoud have proper start date") {
                expect(sut.startDate).to(equal(fixtureStartDate))
            }
            
            it("shoud have proper end date") {
                expect(sut.endDate).to(equal(fixtureEndDate))
            }
            
            it("shoud have proper availability") {
                expect(sut.availability.description ).to(equal(fixtureAvailability.description))   
            }
            
            it("shoud have proper duration") {
                expect(sut.duration).to(equal(fixtureDuration))
            }
            
            it("shoud have proper description") {
                let fixtureDescription = self.fixtureDescription(fixtureStartDate, endDate: fixtureEndDate, duration: fixtureDuration, availability: fixtureAvailability)
                expect(sut.description).to(equal(fixtureDescription))
            }
        }
    }
    
    func fixtureDescription(startDate: NSDate, endDate: NSDate, duration: NSTimeInterval, availability: TimeFrameAvailability) -> String {
        return "\nstart: \(startDate), end: \(endDate), duration: \(duration), availability: \(availability)"
    }
}
