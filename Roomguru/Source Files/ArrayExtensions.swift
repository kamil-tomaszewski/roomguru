//
//  ArrayExtensions.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 19/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension Array {
    
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
    
}