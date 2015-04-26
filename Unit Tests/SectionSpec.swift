//
//  SectionSpec.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 24/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

import Nimble
import Quick

import Roomguru

class SectionSpec: QuickSpec {
    
    override func spec() {
        
        var fixtureItems = [
            FixtureItem(),
            FixtureItem(),
            FixtureItem(),
            FixtureItem()
        ]
        
        let listableFactory = ListableFactory(listableClass: Section<FixtureItem>.self)
        
        itBehavesLike("listable") {
            [
                "items": fixtureItems,
                "listableFactory": listableFactory
            ]
        }
        
        var sut = Section<FixtureItem>(fixtureItems)
        
        beforeEach {
            sut = Section(fixtureItems)
        }
        
        describe("when title is set") {
            let fixtureTitle = "FixtureTitle"
            
            beforeEach {
                sut.title = fixtureTitle
            }
            
            it("should have title") {
                expect(sut.title).to(equal("FixtureTitle"))
            }
        }
        
        describe("when title is not set") {
            it("should not have title") {
                expect(sut.title).to(beNil())
            }
        }
    }
}
