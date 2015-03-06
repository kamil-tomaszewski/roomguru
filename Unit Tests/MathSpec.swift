//
//  MathSpec.swift
//  Project
//
//  Copyright (c) 2015 Netguru Sp. z o.o.All rights reserved.
//

import Nimble
import Quick

class MathSpec: QuickSpec {
    override func spec() {
        
        describe("Math") {
            
            it("is awesome") {
                expect(2+2).to(equal(4));
            }
        }
    }
}
