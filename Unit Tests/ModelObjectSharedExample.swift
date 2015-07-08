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
    var map: ((jsonArray: [JSON]?) -> [ModelObject]?)!
    
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
            let testJSON = configDict["json"] as! TestJSON
            let expectedJSON = (configDict["expectedJSON"] ?? testJSON) as! TestJSON
            let map = configDict["map"] as! [String: String]
            
            var sut: ModelObject!
            
            beforeEach {
                sut = factory.modelObjectWithJSON(testJSON.json)
            }
            
            describe("protocol conformance") {
                
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
            
            describe("mapping JSON to sut") {
                
                beforeEach {
                    sut.map(testJSON.json)
                }
                
                itBehavesLike("mapping JSON to model object") {
                    let sut = factory.modelObjectWithJSON(testJSON.json)
                    sut.map(testJSON.json)
                    return [
                        "sut": sut,
                        "json": expectedJSON,
                        "map": map
                    ]
                }
            }

            describe("mapping array of test objects to array of JSONs") {
                
                let jsons: [JSON] = [testJSON.json]
                let expectedJSONs: [JSON] = [expectedJSON.json]
                var objects = factory.map(jsonArray: jsons)!
                
                it("should map to correct number of objects") {
                    expect(objects.count).to(equal(jsons.count))
                }
                
                for (index, object) in enumerate(objects) {
                    itBehavesLike("mapping JSON to model object") {
                        [
                            "sut": object,
                            "json": TestJSON(json: expectedJSONs[index]),
                            "map": map
                        ]
                    }
                }
            }
        }
    }
}

private class ModelObjectMappingSharedExampleConfiguration: QuickConfiguration {
    override class func configure(configuration: Configuration) {
        sharedExamples("mapping JSON to model object") { (sharedExampleContext: SharedExampleContext) in
            var configDict = sharedExampleContext() as! [String: AnyObject]
            
            let sut = configDict["sut"] as! ModelObject
            let json = (configDict["json"] as! TestJSON).json
            let map = configDict["map"] as! [String: String]
            
            for (jsonKey, objectKey) in map {
                itBehavesLike("object key value") {
                    [
                        "key": objectKey,
                        "value": json[jsonKey].anyObject,
                        "sut": sut
                    ]
                }
            }
        }
    }
}
