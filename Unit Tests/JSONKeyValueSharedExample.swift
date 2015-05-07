//
//  JSONKeyValueSharedExample.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 06/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON

class JSONKeyValueSharedExample: QuickConfiguration {
    override class func configure(configuration: Configuration) {
        sharedExamples("json key value") { (sharedExampleContext: SharedExampleContext) in
            var configDict: [String: AnyObject] = sharedExampleContext() as! [String: AnyObject]
                        
            let key = configDict["key"] as! String
            let value: AnyObject = configDict["value"]!
            let valueJSON = JSON(value)
            let sut = (configDict["sut"] as! TestJSON).json
            
            it("should not be empty") {
                let result = sut.isEmpty
                expect(result).notTo(beTrue())
            }
            
            context("sut for \(key)") {
                
                it("should have correct value") {
                    let result = (sut[key] == valueJSON)
                    expect(result).to(beTrue())
                }
            }
        }
    }
}
