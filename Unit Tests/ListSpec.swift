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

class FixtureItem {}

class ListSpec: QuickSpec {
    
    override func spec() {
     
        itBehavesLike("list") {
            [
                "items": [
                    FixtureItem(),
                    FixtureItem(),
                    FixtureItem(),
                    FixtureItem()
                ]
            ]
        }
        
    }
}
