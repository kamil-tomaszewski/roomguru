//
//  CGPointExtensions.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 27/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension CGPoint {
    
    mutating func increaseYBy(newY: CGFloat) {
        y += newY
    }
}
