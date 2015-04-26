//
//  ListableSharedExample.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import Roomguru

class ListableFactory {
    
    private let listableClass: List<FixtureItem>.Type
    
    init(listableClass: List<FixtureItem>.Type) {
        self.listableClass = listableClass
    }
    
    private func listableWithItems(items: [FixtureItem]) -> List<FixtureItem> {
        return listableClass(items)
    }
}

extension FixtureItem: Equatable {}

func ==(lhs: FixtureItem, rhs: FixtureItem) -> Bool {
    return lhs === rhs
}

class ListableSharedExampleConfiguration : QuickConfiguration {
    override class func configure(configuration: Configuration) {
        sharedExamples("listable") { (sharedExampleContext: SharedExampleContext) in
            var configDict: [String: AnyObject] = sharedExampleContext() as! [String: AnyObject]
            
            let fixtureItems = configDict["items"] as! [FixtureItem]
            let factory = configDict["listableFactory"] as! ListableFactory
            
            var sut = factory.listableWithItems(fixtureItems)
            
            beforeEach {
                sut = factory.listableWithItems(fixtureItems)
            }
            
            describe("when newly initialized") {
                
                it("should not be nil") {
                    expect(sut).notTo(beNil())
                }
                
                it("should have correct items count") {
                    expect(sut.count).to(equal(fixtureItems.count))
                }
                
                context("itemize") {
                    
                    var indexes: [Int] = []
                    var itemizedItems: [FixtureItem] = []
                    
                    beforeEach {
                        sut.itemize { (index, item) in
                            indexes.append(index)
                            itemizedItems.append(item)
                        }
                    }
                    
                    afterEach {
                        indexes = []
                        itemizedItems = []
                    }
                    
                    it("should itemize all items") {
                        let result = (itemizedItems == fixtureItems)
                        expect(itemizedItems.count).to(equal(fixtureItems.count))
                        expect(result).to(beTruthy())
                    }
                    
                    it("should itemize with correct indexes") {
                        expect(indexes.count).to(equal(fixtureItems.count))
                        expect(indexes.first).to(equal(0))
                        expect(indexes.last).to(equal(fixtureItems.count-1))
                    }
                }
            }
            
            describe("subscripting") {
                
                it("should return first item") {
                    let result = sut[0]
                    expect(result).to(equal(fixtureItems.first!))
                }
                
                it("should return last item") {
                    let result = sut[3]
                    expect(result).to(equal(fixtureItems.last!))
                }
            }
            
            describe("operation") {
                
                var itemsCount = 0
                
                context("add item") {
                    
                    let newItem = FixtureItem()
                    let index = 3
                    
                    beforeEach {
                        sut.add(newItem, atIndex: index)
                        itemsCount = sut.count
                    }
                    
                    it("should add item at index 3") {
                        expect(sut[3]).to(beIdenticalTo(newItem))
                    }
                    
                    it("should have higher count") {
                        expect(itemsCount).to(equal(fixtureItems.count+1))
                    }
                }
                
                context("remove item") {
                    
                    var index = 2
                    let fixtureItem = sut[index]
                    var removedItem = FixtureItem()
                    
                    beforeEach {
                        removedItem = sut.remove(index)
                        itemsCount = sut.count
                    }
                    
                    it("should remove item at index \(index)") {
                        expect(removedItem).to(beIdenticalTo(fixtureItem))
                        expect(sut[index]).notTo(beIdenticalTo(fixtureItem))
                    }
                    
                    it("should not contain certain item at index \(index)") {
                        let result = contains(sut.fixtureItems(), fixtureItem)
                        expect(result).notTo(beTruthy())
                    }
                    
                    it("should have lower count") {
                        expect(itemsCount).to(equal(fixtureItems.count-1))
                    }
                }
            }
        }
    }
}

private extension List {
    
    func fixtureItems() -> [T] {
        return items
    }
}
