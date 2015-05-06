//
//  AttendeeSpec.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 06/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON

private extension Attendee {
    
    var rawStatus: String {
        get { return status?.rawValue ?? "fixtureIncorrectStatus" }
    }
}

class AttendeeSpec: QuickSpec {
    
    override func spec() {
        
        var factory = ModelObjectFactory(modelObjectClass: Attendee.self)
        var json: JSON!
        var map = [
            "displayName": "name",
            "email": "email",
            "responseStatus": "rawStatus"
        ] as [String: String]
        
        context("correct json") {
        
            beforeEach {
                json = JSON([
                    "displayName": "fixtureName",
                    "email": "fixtureEmail",
                    "responseStatus": "accepted"
                ])
            }
            
            itBehavesLike("model object") {
                [
                    "factory": factory,
                    "json": TestJSON(json: json),
                    "map": map
                ]
            }
        }
        
        context("incorrect json") {

            beforeEach {
                json = JSON([
                    "displayName": "fixtureName",
                    "email": "fixtureEmail",
                    "responseStatus": "fixtureIncorrectStatus"
                ])
            }
            
            itBehavesLike("model object") {
                [
                    "factory": factory,
                    "json": TestJSON(json: json),
                    "map": map
                ]
            }
        }
    }
}
