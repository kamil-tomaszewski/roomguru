//
//  ModelObjectSpec.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 05/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick
import SwiftyJSON

extension ModelObject {
    var fixtureProperty: String {
        get { return "fixtureValue" }
        set {}
    }
}

class MockModelObject: ModelObject {
    required init(json: JSON) { super.init(json: json) }
    
    // MARK: Stubs
    override func map(json: JSON) {}

    override class func map<T : ModelJSONProtocol>(jsonArray: [JSON]?) -> [T]? {
        return jsonArray?.map { T(json: $0) }
    }
}

class ModelObjectSpec: QuickSpec {
    
    override func spec() {
        let factory = ModelObjectFactory(modelObjectClass: MockModelObject.self)
        factory.map = { return MockModelObject.map($0) as [MockModelObject]? }
        let json = TestJSON(json: JSON([ "fixtureKey": "fixtureValue" ]))
        
        itBehavesLike("model object") {
            [
                "factory": factory,
                "json": json,
                "map": ["fixtureKey": "fixtureProperty"]
            ]
        }
    }    
}
