//
//  CalendarPersistenceStoreSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 23/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import Roomguru
import SwiftyJSON

class CalendarPersistenceStoreSpec: QuickSpec {
    override func spec() {
        
        let sut = CalendarPersistenceStore.sharedStore
        
        afterEach {
            sut.clear()
        }
        
        describe("when newly initialized") {
            
            it("should be initialized as shared manager") {
                expect(CalendarPersistenceStore.sharedStore).to(beIdenticalTo(sut))
            }
            
            it("should have no data") {
                expect(sut.calendars.count).to(equal(0))
            }
        }
        
        describe("when adding and saving calendar to store") {
            
            context("with summary") {
                
                let json = JSON(["id" : "Fixture Identifier", "summary" : "Fixture Summary"])
                let calendar = Calendar(json: json)
                calendar.name = "Fixture Name"
                
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
                
                it("should not match other calendar") {
                    let json = JSON(["id" : "Other Fixture Identifier", "summary" : "Other Fixture Summary"])
                    var calendar = Calendar(json: json)
                    expect(sut.matchingCalendar(calendar)).to(beNil())
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
                
                let json = JSON(["id" : "Fixture Identifier"])
                let calendar = Calendar(json: json)
                
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
