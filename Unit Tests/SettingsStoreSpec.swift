//
//  SettingsStoreSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

class SettingsStoreSpec: QuickSpec {
    override func spec() {
        
        var sut: SettingsStore?
        
        beforeEach {
            sut = SettingsStore()
        }
        
        afterEach {
            sut = nil
        }
        
        it("should have notification disabled") {
            expect(sut!.isNotificationEnabled()).to(beFalse())
        }
        
        describe("when enable notification") {
            
            beforeEach {
                sut!.enableNotification(true)
            }
            
            it("should have notification enabled") {
                expect(sut!.isNotificationEnabled()).to(beTrue())
            }
            
            describe("and disabling them") {
                
                beforeEach {
                    sut!.enableNotification(false)
                }
                
                it("should have notification disabled") {
                    expect(sut!.isNotificationEnabled()).to(beFalse())
                }
            }
        }
    }
}
