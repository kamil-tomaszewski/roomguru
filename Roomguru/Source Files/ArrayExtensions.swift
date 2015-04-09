//
//  ArrayExtensions.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 19/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension Array {
    
    //temp nothing in here
}

func removeOccurencesOfElement<T: Equatable>(array: [T], element: T) -> [T] {
    
    for (index, value) in enumerate(array) {
        if value == element {
            return array.filter {$0 != value}
        }
    }
    return array
}
