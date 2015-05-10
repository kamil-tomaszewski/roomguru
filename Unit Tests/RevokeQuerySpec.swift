//
//  RevokeQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 05.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick


class RevokeQuerySpec: QuickSpec {
        
    override func spec(){
        
        var fixtureEventID = "FixtureIdentifier"
        var fixtureUserEmail = "FixtureUserEmail"
        var URLExtension: String = "/calendars/" + fixtureUserEmail + "/events/" + fixtureEventID
        var testQuery: RevokeQuery!
        let mockQuery = MockQuery(HTTPMethod: "DELETE", URLExtension: URLExtension, parameterEncoding: "URL")
        
        describe("when initializing") {
            testQuery = RevokeQuery(eventID: fixtureEventID, userEmail: fixtureUserEmail)
            
            itBehavesLike("queryable") {
                [
                    "testQuery": testQuery,
                    "mockQuery": mockQuery,
                ]
            }
            
            it("should have proper parameters") {
                expect(testQuery.parameters).to(beNil())
            }
        }
    }
}
