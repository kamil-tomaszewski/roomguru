//
//  CalendarSpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 28.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON

class CalendarSpec: QuickSpec {
    
    override func spec() {
        
        var factory = ModelObjectFactory(modelObjectClass: Calendar.self)
        factory.map = { return Calendar.map($0) as [Calendar]? }
        
        var map = [
            "accessRole": "accessRole",
            "etag": "etag",
            "id": "identifier",
            "kind": "kind",
            "summary": "summary",
            "timeZone": "timezone",
            "backgroundColor": "colorHex"
            ] as [String: String]
            
        itBehavesLike("model object") {
            var localJSON = JSON([
                "accessRole": "fixtureAccessRole",
                "etag": "fixtureEtag",
                "id": "fixtureIdentifier",
                "kind": "fixtureKind",
                "summary": "fixtureSummary",
                "timeZone": "fixtureTimezone",
                "backgroundColor": "fixtureColorHex"
                ])
            
            return [
                "factory": factory,
                "json": TestJSON(json: localJSON),
                "map": map
            ]
        }
        
        context("calendar identifier contains resource identifier") {
            
            var localJSON = JSON([
                "accessRole": "fixtureAccessRole",
                "etag": "fixtureEtag",
                "id": "fixtureIdentifier.resource.calendar.google.com",
                "kind": "fixtureKind",
                "summary": "fixtureSummary",
                "timeZone": "fixtureTimezone",
                "backgroundColor": "fixtureColorHex"
                ])
            
            let sut = Calendar(json: localJSON)
            
            it("should be resource") {
                expect(sut.isResource()).to(beTrue())
            }
        }
        
        context("calendar identifier does not contain resource identifier") {
            
            var localJSON = JSON([
                "accessRole": "fixtureAccessRole",
                "etag": "fixtureEtag",
                "id": "fixtureIdentifier",
                "kind": "fixtureKind",
                "summary": "fixtureSummary",
                "timeZone": "fixtureTimezone",
                "backgroundColor": "fixtureColorHex"
                ])
            
            let sut = Calendar(json: localJSON)
            
            it("should not be resource") {
                expect(sut.isResource()).to(beFalse())
            }
        }
        
        context("calendars with the same identifiers") {
            
            var localJSON = JSON([
                "accessRole": "fixtureAccessRole",
                "etag": "fixtureEtag",
                "id": "fixtureIdentifier",
                "kind": "fixtureKind",
                "summary": "fixtureSummary",
                "timeZone": "fixtureTimezone",
                "backgroundColor": "fixtureColorHex"
                ])
            
            var mockLocalJSON = JSON([
                "accessRole": "differentFixtureAccessRole",
                "etag": "differentFixtureEtag",
                "id": "fixtureIdentifier",
                "kind": "differentFixtureKind",
                "summary": "differentFixtureSummary",
                "timeZone": "differentFixtureTimezone",
                "backgroundColor": "differentFixtureColorHex"
                ])
            
            let sut = Calendar(json: localJSON)
            let mockCalendar = Calendar(json: mockLocalJSON)
            
            it("should be equal") {
                expect(sut == mockCalendar).to(beTrue())
            }
        }
        
        context("calendars with different identifiers") {
            
            var localJSON = JSON([
                "accessRole": "fixtureAccessRole",
                "etag": "fixtureEtag",
                "id": "fixtureIdentifier",
                "kind": "fixtureKind",
                "summary": "fixtureSummary",
                "timeZone": "fixtureTimezone",
                "backgroundColor": "fixtureColorHex"
                ])
            
            var mockLocalJSON = JSON([
                "accessRole": "fixtureAccessRole",
                "etag": "fixtureEtag",
                "id": "differentFixtureIdentifier",
                "kind": "fixtureKind",
                "summary": "fixtureSummary",
                "timeZone": "fixtureTimezone",
                "backgroundColor": "fixtureColorHex"
                ])
            
            let sut = Calendar(json: localJSON)
            let mockCalendar = Calendar(json: mockLocalJSON)
            
            it("should not be equal") {
                expect(sut == mockCalendar).to(beFalse())
            }
        }

    }
}
