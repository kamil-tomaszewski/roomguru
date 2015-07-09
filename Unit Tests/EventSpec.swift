//
//  EventSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 09/07/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick
import SwiftyJSON
import DateKit

class EventSpec: QuickSpec {
    
    override func spec() {
        
        var sut: Event!
        
        describe("when initialized with JSON") {
            
            beforeEach {
                sut = Event(json: self.json())
            }
    
            afterEach {
                sut = nil
            }
            
            it("name should be set properly") {
                expect(sut.identifier).to(equal("Fixture Event ID"))
            }
            
            it("summary should be set properly") {
                expect(sut.summary).to(equal("Fixture Summary"))
            }
            
            it("htmlLink should be set properly") {
                expect(sut.htmlLink).to(equal("Fixture HTML Link"))
            }
            
            it("status should be set properly") {
                expect(sut.status).to(equal(EventStatus.Confirmed.rawValue))
            }
            
            it("should have proper number of rooms") {
                expect(sut.rooms.count).to(equal(1))
            }
            
            it("should have proper number of attendees") {
                expect(sut.attendees.count).to(equal(1))
            }
            
            it("should have properly set creator") {
                expect(sut.creator).toNot(beNil())
            }
            
            it("should have properly set startDate") {
                let expectedDate = NSDate(timeIntervalSince1970: 0).midnight.hour(10).day(24).month(4).year(2015).date
                expect(sut.start).to(equal(expectedDate))
            }
            
            it("should have properly set endDate") {
                let expectedDate = NSDate(timeIntervalSince1970: 0).midnight.hour(10).minute(1).day(24).month(4).year(2015).date
                expect(sut.end).to(equal(expectedDate))
            }

            it("should have properly formatted startTime") {
                expect(sut.startTime).to(equal("10:00 AM"))
            }
            
            it("should have properly formatted endTime") {
                expect(sut.endTime).to(equal("10:01 AM"))
            }
            
            it("should have proper duration") {
                expect(sut.duration).to(equal(60.0))
            }
            
            describe("when setting custom summary") {
                
                beforeEach {
                    sut.setCustomSummary("Fixture Custom Summary")
                }
                
                it("summary should be change to custom") {
                    expect(sut.summary).to(equal("Fixture Custom Summary"))
                }
            }
            
            context("after archving") {
                
                var archivedEvent: NSData!
                
                beforeEach {
                    archivedEvent = NSKeyedArchiver.archivedDataWithRootObject(sut)
                }
                
                afterEach {
                    archivedEvent = nil
                }
                
                context("and unarchiving") {
                    
                    var unarchivedEvent: Event!
                    
                    beforeEach {
                        unarchivedEvent = NSKeyedUnarchiver.unarchiveObjectWithData(archivedEvent) as! Event
                    }
                    
                    afterEach {
                        unarchivedEvent = nil
                    }
                    
                    it("should calendarEntry have the same calendarID") {
                        expect(sut.identifier).to(equal(unarchivedEvent.identifier))
                    }
                }
            }
        }
        
        describe("when initialize without arguments") {
            
            beforeEach {
                sut = Event()
            }
            
            afterEach {
                sut = nil
            }
            
            it("should be initialize properly") {
                expect(sut).toNot(beNil())
            }
        }
    }
}

private extension EventSpec {
    
    func json() -> JSON {
        return JSON([
            "id" : "Fixture Event ID",
            "summary" : "Fixture Summary",
            "status" : EventStatus.Confirmed.rawValue,
            "htmlLink" : "Fixture HTML Link",
            "start" : ["dateTime" : "2015-04-24T01:00:00-07:00"],
            "end" : ["dateTime" : "2015-04-24T01:01:00-07:00"],
            "attendees" : [
                [
                    "email" : "Fixture Email Address",
                    "responseStatus" : "accepted",
                    "displayName" : "Fixture Display Name",
                    "organizer" : "true"
                ],[
                    "email" : "Fixture Resource ID",
                    "displayName" : "Fixture Resource Display Name",
                    "responseStatus" : "accepted",
                    "resource" : "true",
                    "self" : "true"
                ]
            ],
            "creator" : [
                "email" : "Fixture Email Address",
                "responseStatus" : "accepted",
                "displayName" : "Fixture Display Name",
                "self" : "true"
            ]
        ])
    }
}
