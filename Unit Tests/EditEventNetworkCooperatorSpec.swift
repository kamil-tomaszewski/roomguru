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
            
            context("and server responds") {
                
                class MockNetworkManager: NetworkManager {
                    
                    let shoulReturnBusyEventInProvidedHours: Bool
                    
                    init(shoulReturnBusyEventInProvidedHours: Bool) {
                        self.shoulReturnBusyEventInProvidedHours = shoulReturnBusyEventInProvidedHours
                        super.init()
                    }
                    
                    override func request(query: Query, success: ResponseBlock, failure: ErrorBlock) {

                        /* NOTICE:
                         * Becuase saveEvent() method of sut calls request method of NetworkManager twice (private checkEventsAvailability() and save() ),
                         * it's needed to distinguish responses by query type
                         */
                        if query is EventQuery {
                            let response = [
                                "id" : "Fixture Event ID",
                                "start" : ["dateTime" : "2015-04-24T01:00:00-07:00", "timeZone" : "Europe/Warsaw"],
                                "end" : ["dateTime" : "2015-04-24T01:01:00-07:00", "timeZone" : "Europe/Warsaw"],
                                "attendees" : [
                                    [
                                        "email" : "Fixture Organizer Email Address",
                                        "responseStatus" : "accepted",
                                        "displayName" : "Fixture Organizer Display Name",
                                        "organizer" : "true"
                                    ],[
                                        "email" : "Fixture Resource ID",
                                        "displayName" : "Fixture Resource Display Name",
                                        "responseStatus" : "accepted",
                                        "resource" : "true"
                                    ]
                                ],
                                "organizer" : [
                                    "email" : "Fixture Organizer Email Address",
                                    "self" : "true",
                                    "displayName" : "Fixture Organizer Display Name"
                                ]
                            ]
                            
                            success(response: JSON(response))
                        
                        } else if query is FreeBusyQuery {
                            
                            let busy: [String : AnyObject] = shoulReturnBusyEventInProvidedHours ?
                                ["start" : "2015-04-24T00:22:00+02:00", "end" : "2015-04-24T10:30:00+02:00"] :
                                ["start" : "2015-04-24T00:00:00+02:00", "end" : "2015-04-24T10:30:00+02:00"]
                            
                            
                            let response = [
                                "timeMin" : "2015-04-23T22:00:00.000Z",
                                "timeMax" : "2015-04-25T22:00:00.000Z",
                                "kind" : "calendar#Fixture Calendar Type",
                                "calendars" : [
                                    "Fixture Calendar ID" : [
                                        "busy" : busy
                                    ]
                                ]
                            ]
                            
                            success(response: JSON(response))
                        }
                    }
                }
                
                context("and event is busy at provided hours") {
                    
                    beforeEach {
                        sut = EditEventNetworkCooperator(usingMockNetworkManager: MockNetworkManager(shoulReturnBusyEventInProvidedHours: true), query: self.mockEventQuery())
                        sut.saveEvent() { (event, error) in
                            anEvent = event
                            anError = error
                        }
                    }
                    
                    it("error should be nil") {
                        expect(anError).toNot(beNil())
                    }
                    
                    it("event should be nil") {
                        expect(anEvent).to(beNil())
                    }
                }
                
                context("and event is free at provided hours") {
                    
                    beforeEach {
                        sut = EditEventNetworkCooperator(usingMockNetworkManager: MockNetworkManager(shoulReturnBusyEventInProvidedHours: false), query: self.mockEventQuery())
                        sut.saveEvent() { (event, error) in
                            anEvent = event
                            anError = error
                        }
                    }
                    
                    it("error should not be nil") {
                        expect(anError).toNot(beNil())
                    }
                    
                    it("event should be nil") {
                        expect(anEvent).to(beNil())
                    }
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
