//
//  CalendarPickerViewModelSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON

class CalendarPickerViewModelSpec: QuickSpec {
    override func spec() {
        
        var sut: CalendarPickerViewModel?
        
        describe("when initializing with event") {
            
            beforeEach {
                sut = CalendarPickerViewModel(calendars: self.mockedCalendars())
            }
            
            afterEach {
                sut = nil
            }
            
            it("should filter resource calendars and contain 3 calendars") {
                expect(sut!.count).to(equal(3))
            }
            
            it("should not procceed when any of calendar is not selected") {
                expect(sut!.shouldProcceed).to(beFalse())
            }
            
            it("should not select any calendar") {
                for index in 0..<3 {
                    expect(sut!.shouldSelectCalendarAtIndex(index)).to(beFalse())
                }
            }
            
            describe("when selecting calendar") {
                
                beforeEach {
                    sut!.selectOrDeselectCalendarAtIndex(0)
                }
                
                it("should allow to procceed") {
                    expect(sut!.shouldProcceed).to(beTrue())
                }
                
                it("should select only 1st calendar") {
                    expect(sut!.shouldSelectCalendarAtIndex(0)).to(beTrue())
                    for index in 1..<3 {
                        expect(sut!.shouldSelectCalendarAtIndex(index)).to(beFalse())
                    }
                }
                
                describe("when deselcting previous selected calendar") {
                    
                    beforeEach {
                        sut!.selectOrDeselectCalendarAtIndex(0)
                    }
                    
                    it("should not allow to procceed") {
                        expect(sut!.shouldProcceed).to(beFalse())
                    }
                    
                    it("should not select any calendar") {
                        for index in 0..<3 {
                            expect(sut!.shouldSelectCalendarAtIndex(index)).to(beFalse())
                        }
                    }
                }
            }
            
            describe("when selecting all calendars") {
                
                beforeEach {
                    sut!.selectAll()
                }
                
                it("should allow to procceed") {
                    expect(sut!.shouldProcceed).to(beTrue())
                }
                
                it("should select only 1st calendar") {
                    for index in 0..<3 {
                        expect(sut!.shouldSelectCalendarAtIndex(index)).to(beTrue())
                    }
                }
            }
            
            describe("when customizing name") {
                
                beforeEach {
                    sut!.saveNameForCalendarAtIndexWithSelection(0, name: "Fixture customize name")
                }
                
                it("main text for calendar should contain customized name") {
                    expect(sut!.textForCalendarAtIndex(0).mainText).to(contain("Fixture customize name"))
                }
                
                it("detail text for calendar should contain summary") {
                    
                    expect(sut!.textForCalendarAtIndex(0).detailText).to(contain("Fixture Summary.1"))
                }
                
                it("should customized calendar be selected") {
                    expect(sut!.shouldSelectCalendarAtIndex(0)).to(beTrue())
                }
                
                it("should have customized name") {
                    expect(sut!.hasCalendarAtIndexCustomizedName(0)).to(beTrue())
                }
                
                describe("and reseting it") {
                    
                    beforeEach {
                        sut!.resetCustomCalendarNameAtIndex(0)
                    }
                    
                    it("text for calendar should not contain customized name") {
                        expect(sut!.textForCalendarAtIndex(0).mainText).toNot(contain("Fixture customize name"))
                    }
                    
                    it("detail text for calendar should contain default message") {
                        expect(sut!.textForCalendarAtIndex(0).detailText).to(contain("Not changed"))
                    }
                    
                    it("should reseted calendar be still selected") {
                        expect(sut!.shouldSelectCalendarAtIndex(0)).to(beTrue())
                    }
                    
                    it("should not have customized name") {
                        expect(sut!.hasCalendarAtIndexCustomizedName(0)).to(beFalse())
                    }
                }
            }
        }
    }
}

private extension CalendarPickerViewModelSpec {
    
    func mockedCalendars() -> [Calendar] {
        
        return [
            mockCalendarWithID("Fixture ID.1", accessRole: "Fixture Access Role.1", summary: "Fixture Summary.1", etag: "Fixture etag.1", resource: true),
            mockCalendarWithID("Fixture ID.2", accessRole: "Fixture Access Role.2", summary: "Fixture Summary.2", etag: "Fixture etag.2", resource: true),
            mockCalendarWithID("Fixture ID.3", accessRole: "Fixture Access Role.3", summary: "Fixture Summary.3", etag: "Fixture etag.3", resource: true),
            mockCalendarWithID("Fixture ID.4", accessRole: "Fixture Access Role.4", summary: "Fixture Summary.4", etag: "Fixture etag.4", resource: false),
        ]
    }
    
    func mockCalendarWithID(id: String, accessRole: String, summary: String, etag: String, resource: Bool) -> Calendar {
        
        return Calendar(json: JSON([
            "id" : resource ? id + "resource.calendar.google.com" : id,
            "accessRole" : accessRole,
            "summary" : summary,
            "etag" : etag
        ]))
    }
}
