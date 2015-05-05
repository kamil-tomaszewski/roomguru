//
//  GroupedListViewModelSpec.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 04/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

class GroupedListViewModelSpec: QuickSpec {
    
    class FixtureGroupListItem: FixtureListItem {}
    
    override func spec() {
        
        var fixtureItems = [
            FixtureGroupListItem(title: "FixtureText"),
            FixtureListItem(title: "FixtureText2"),
            FixtureListItem(title: "FixtureText"),
            FixtureListItem(title: "FixtureText")
        ]
        
        let factory = ListViewModelFactory(viewModelClass: GroupedListViewModel<FixtureListItem>.self)
        
        itBehavesLike("list view model") {
            [
                "items": fixtureItems,
                "sectionsCount": 2,
                "listViewModelFactory": factory
            ]
        }
        
        describe("extended index path operatable") {
            
            var sut: GroupedListViewModel<FixtureListItem>!
            var indexPaths: [NSIndexPath]?
            
            beforeEach {
                sut = GroupedListViewModel(fixtureItems, sortingKey: "title")
            }
            
            afterEach {
                indexPaths = []
            }
            
            context("index paths for items") {
                
                beforeEach {
                    var items: [GroupItem] = []
                    items.append(sut[0][0])
                    items.append(sut[0][1])
                    items.append(sut[0][2])
                    indexPaths = sut.indexPathsForItems(items)
                }
                
                it("should return correct index paths") {
                    let expectedIndexPaths: [NSIndexPath] = [
                        NSIndexPath(forRow: 0, inSection: 0),
                        NSIndexPath(forRow: 1, inSection: 0),
                        NSIndexPath(forRow: 2, inSection: 0)
                    ]
                    
                    expect(indexPaths!).to(equal(expectedIndexPaths))
                }
            }
            
            context("index paths for items of type") {

                beforeEach {
                    indexPaths = sut.indexPathsForItemOfType(FixtureGroupListItem.self)
                }
                
                it("should return correct index paths") {
                    let expectedIndexPaths: [NSIndexPath] = [NSIndexPath(forRow: 0, inSection: 0)]
                    expect(indexPaths!).to(equal(expectedIndexPaths))
                }
            }
        }
    }
}
