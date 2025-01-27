//
//  CalendarPersistenceStoreSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 23/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON

class CalendarPersistenceStoreSpec: QuickSpec {
    override func spec() {
        
        var sut: CalendarPersistenceStore!
        
        beforeEach {
            sut = CalendarPersistenceStore()
        }
        
        afterEach {
            sut.clear()
            sut = nil
        }
        
        afterSuite {
            CalendarPersistenceStore.sharedStore.clear()
        }
        
        describe("when newly initialized") {
            
            it("should be initialized as shared manager") {
                let sharedStore = CalendarPersistenceStore.sharedStore
                expect(CalendarPersistenceStore.sharedStore).to(beIdenticalTo(sharedStore))
            }
            
            it("should have no data") {
                expect(sut.calendars.count).to(equal(0))
            }
        }
        
        describe("when adding and saving calendar to store") {
            
            context("with summary") {
                let calendar = self.calendarWithIdentifier("Fixture Identifier", summary: "Fixture Summary", name: "Fixture Name")
                
                beforeEach {
                    sut.saveCalendars([calendar])
                }
                
                it("should have 1 calendar") {
                    expect(sut.calendars.count).to(equal(1))
                }
                
                it("should persist given calendar") {
                    expect(sut.isCalendarPersisted(calendar)).to(beTruthy())
                }
                
                it("should match calendar") {
                    let actualCalendar = sut.matchingCalendar(calendar)
                    expect(actualCalendar).to(beIdenticalTo(calendar))
                }
                
                it("should return name for proper id") {
                    let name = sut.nameMatchingID("Fixture Identifier")
                    expect(name).to(equal("Fixture Name"))
                }
                
                it("should return empty string for improper id") {
                    let name = sut.nameMatchingID("Wrong Fixture Identifier")
                    expect(name).to(equal(""))
                }
                
                it("should not match other calendar") {
                    let otherCalendar = self.calendarWithIdentifier("Other Fixture Identifier", summary: "Other Fixture Summary")
                    expect(sut.matchingCalendar(otherCalendar)).to(beNil())
                }
                
                it("should have 1 room") {
                    expect(sut.rooms().count).to(equal(1))
                }
                
                it("should room has proper id and name") {
                    let room = sut.rooms().first
                    expect(room!.name).to(equal("Fixture Name"))
                    expect(room!.id).to(equal("Fixture Identifier"))
                }
                
                context("after removing added calendar") {
                    
                    beforeEach {
                        sut.clear()
                    }
                    
                    it("should have no calendars") {
                        expect(sut.calendars.count).to(equal(0))
                    }
                }
            }
            
            context("without summary") {
                
                let calendar = self.calendarWithIdentifier("Other Fixture Identifier")
                
                beforeEach {
                    sut.saveCalendars([calendar])
                }
                
                it("should have 0 rooms") {
                    expect(sut.rooms().count).to(equal(0))
                }
            }
        }
    }
}

private extension CalendarPersistenceStoreSpec {
    
    func calendarWithIdentifier(identifier: String, summary: String? = nil, name: String? = nil) -> Calendar {
        var json = ["id" : identifier]
        if let summary = summary {
            json["summary"] = summary
        }
        let calendar = Calendar(json: JSON(json))
        calendar.name = name
        return calendar
    }
}
