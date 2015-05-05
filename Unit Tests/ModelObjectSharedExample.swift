//
//  ModelObjectSharedExample.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 05/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick
import SwiftyJSON

class TestJSON {
    
    let json: JSON
    
    init(json: JSON) {
        self.json = json
    }
}

class ModelObjectFactory {
    
    private let modelObjectClass: ModelObject.Type
    
    init(modelObjectClass: ModelObject.Type) {
        self.modelObjectClass = modelObjectClass
    }
    
    func modelObjectWithJSON(json: JSON) -> ModelObject {
        return modelObjectClass(json: json)
    }
}

class ModelObjectSharedExampleConfiguration: QuickConfiguration {
    
    override class func configure(configuration: Configuration) {
        sharedExamples("model object") { (sharedExampleContext: SharedExampleContext) in
            var configDict: [String: AnyObject] = sharedExampleContext() as! [String: AnyObject]
            
            let factory = configDict["factory"] as! ModelObjectFactory
            let json = (configDict["json"] as! TestJSON).json
            
            var sut: ModelObject!
            
            describe("protocol conformance") {
                
                beforeEach {
                    sut = factory.modelObjectWithJSON(json)
                }
                
                it("should implement ModelJSONProtocol") {
                    let result = (sut as Any) is ModelJSONProtocol
                    expect(result).to(beTrue())
                }
                
                it("should be a subclass of NSObject") {
                    let result = (sut as Any) is NSObject
                    expect(result).to(beTrue())
                }
            }
            
            describe("when newly initialized") {
                
                beforeEach {
                    sut = factory.modelObjectWithJSON(json)
                }
                
                context("date formatter") {
                    
                    var expectedDateFormat: String!
                    var localTimeZone: NSTimeZone!
                    
                    beforeEach {
                        expectedDateFormat = "yyyy-MM-dd'T'HH:mm:ss.ZZZZZ"
                        localTimeZone = NSTimeZone.localTimeZone()
                    }
                    
                    it("should have correct date format") {
                        expect(sut.formatter.dateFormat).to(equal(expectedDateFormat))
                    }
                    
                    it("should be localized to local time zone") {
                        expect(sut.formatter.timeZone).to(equal(localTimeZone))
                    }
                }
            }
        }
    }
}
