//
//  RootScreenSpec.swift
//  Project
//
//  Copyright (c) 2015 Netguru Sp. z o.o.All rights reserved.
//

import KIF
import XCTest

class RootScreenSpec: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShouldHelloTextBeVisible() {
        self.tester().waitForViewWithAccessibilityLabel("Hello, worldguru!")
    }

}
