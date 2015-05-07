//
//  JSONExtensions.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 06/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import SwiftyJSON

extension JSON {
    
    var anyObject: AnyObject {
        get { return object as AnyObject }
    }
}
