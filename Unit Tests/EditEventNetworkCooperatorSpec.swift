//
//  EditEventNetworkCooperatorSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 25/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick
import SwiftyJSON

class EditEventNetworkCooperatorSpec: QuickSpec {
    override func spec() {
        
        var sut: EditEventNetworkCooperator!
        var anEvent: Event?
        var anError: NSError?
        
        afterEach {
            sut = nil
            anEvent = nil
            anError = nil
        }

        describe("when newly initialized") {
            
            beforeEach {
                sut = EditEventNetworkCooperator(query: self.mockEventQuery())
            }
            
            it("query should not be nil") {
                expect(sut.eventQuery).toNot(beNil())
            }
        }
        
        describe("when saving event") {
            
            pending("and server responds") {
                
                class MockNetworkManager: NetworkManager {
                    override func request(query: Query, success: ResponseBlock, failure: ErrorBlock) {
                        
                        if query is EventQuery {
                            
                        } else if query is FreeBusyQuery {
                            
                        }
                    }
                }
                
                pending("and event is busy at provided hours") {
                    
                }
                
                pending("and event is free at provided hours") {
                    
                }
                
            }
            
            describe("and an error did appear") {
                
                class MockNetworkManager: NetworkManager {
                    override func request(query: Query, success: ResponseBlock, failure: ErrorBlock) {
                        failure(error: NSError(message: "Fixture Error Message"))
                    }
                }
                
                beforeEach {
                    sut = EditEventNetworkCooperator(usingMockNetworkManager: MockNetworkManager(), query: self.mockEventQuery())
                    sut.saveEvent() { (event, error) in
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
        }
    }
}

private extension EditEventNetworkCooperator {
    
    convenience init(usingMockNetworkManager networkManager: NetworkManager, query: EventQuery) {
        self.init(query: query)
        self.networkManager = networkManager
    }
}

private extension EditEventNetworkCooperatorSpec {
    
    func mockEventQuery() -> EventQuery {
        
        let calendarEntry = CalendarEntry(calendarID: "Fixture Calendar ID", event: mockedEvent())
        return EventQuery(calendarEntry: calendarEntry)
    }
    
    func mockedEvent() -> Event {
        
        return Event(json: JSON([
            "id" : "Fixture Event ID",
            "summary" : "Fixture Summary",
            "status" : EventStatus.Confirmed.rawValue,
            "htmlLink" : "",
            "start" : ["dateTime" : "2015-04-24T01:00:00-07:00"],
            "end" : ["dateTime" : "2015-04-24T01:01:00-07:00"],
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
            ]]))
    }
}
