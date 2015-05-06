//
//  ObjectKeyValueSharedExample.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 06/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

class ObjectKeyValueSharedExample: QuickConfiguration {
    override class func configure(configuration: Configuration) {
        sharedExamples("object key value") { (sharedExampleContext: SharedExampleContext) in
            var configDict: [String: AnyObject] = sharedExampleContext() as! [String: AnyObject]
            
            let key = configDict["key"] as! String
            let value: AnyObject = configDict["value"]!
            let sut = configDict["sut"] as! NSObject
            
            it("should have key") {
                let result = sut.respondsToSelector(Selector(key))
                expect(result).to(beTrue())
            }
            
            context("sut for \(key)") {
                
                it("should have correct value") {
                    let result: AnyObject = sut.valueForKey(key)!
                    expect(result).to(equal(value))
                }
            }
        }
    }
}
