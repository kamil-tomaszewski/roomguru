//
//  ListViewModelSpec.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 26/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

import Nimble
import Quick

import Roomguru

class ListViewModelSpec: QuickSpec {
    
    override func spec() {
        
        var fixtureItems = [
            FixtureListItem(fixtureText: "FixtureText"),
            FixtureListItem(fixtureText: "FixtureText2"),
            FixtureListItem(fixtureText: "FixtureText"),
            FixtureListItem(fixtureText: "FixtureText")
        ]
        
        let factory = ListViewModelFactory(viewModelClass: ListViewModel<FixtureListItem>.self)
        
        itBehavesLike("list view model") {
            [
                "items": fixtureItems,
                "sectionsCount": 2,
                "listViewModelFactory": factory
            ]
        }
    }
}
