//
//  ListSpec.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import Roomguru

class ListSpec: QuickSpec {
    
    override func spec() {
     
        let fixtureItems = [
            FixtureItem(),
            FixtureItem(),
            FixtureItem(),
            FixtureItem()
        ]
        
        let listableFactory = ListableFactory(listableClass: List<FixtureItem>.self)
        
        itBehavesLike("listable") {
            [
                "items": fixtureItems,
                "listableFactory": listableFactory
            ]
        }
    }
}
