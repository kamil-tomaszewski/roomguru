//
//  SettingsViewModelSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

class SettingsViewModelSpec: QuickSpec {
    override func spec() {
        
        var sut: SettingsViewModel<SettingItem>?
        
        beforeEach {
            sut = SettingsViewModel<SettingItem>([
                SettingItem(title: NSLocalizedString("Fixture title.1", comment: ""), mode: .Selectable, action: Selector("fixture selectable selector")),
                SettingItem(title: NSLocalizedString("Fixture title.2", comment: ""), mode: .Switchable, action: Selector("fixture switchable selector"))
            ])
        }
        
        afterEach {
            sut = nil
        }
        
        describe("when newly created") {
            
            it("should have 2 items") {
                expect(sut![0].count).to(equal(2))
            }
            
            it("should have selectable item at index 0") {
                expect(sut!.isSelectableItemAtIndex(0)).to(beTrue())
            }
            
            it("should not have selectable item at index 1") {
                expect(sut!.isSelectableItemAtIndex(1)).to(beFalse())
            }
        }
    }
}
