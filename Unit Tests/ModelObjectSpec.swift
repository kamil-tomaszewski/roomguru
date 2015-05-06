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

class ModelObjectSpec: QuickSpec {
    
    override func spec() {
        
        class MockModelObject: ModelObject {
            required init(json: JSON) { super.init(json: json) }
            override func map(json: JSON) {}
        }
        
        let factory = ModelObjectFactory(modelObjectClass: MockModelObject.self)
        let json = TestJSON(json: JSON(NSData()))
        
        itBehavesLike("model object") {
            [
                "factory": factory,
                "json": json
            ]
        }
    }
}
