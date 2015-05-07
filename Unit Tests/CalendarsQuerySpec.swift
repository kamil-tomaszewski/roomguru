//
//  CalendarsQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 05.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON

class CalendarsQuerySpec: QuickSpec {
    
    override func spec(){
        
        var sut: CalendarsQuery?
        
        describe("when initializing") {
            
            beforeEach {
                sut = CalendarsQuery()
            }
            
            afterEach {
                sut = nil
            }
            
            it("should have proper URL extension") {
                let URLExtension = "/users/me/calendarList"
                expect(sut!.URLExtension).to(equal(URLExtension))
            }
        }
    }
}
