//
//  ResultActionItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 27/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class ResultActionItem: ActionItem {
    var result: AnyObject?
    var validation: ((object: AnyObject) -> NSError?)?
    private var _validationError: NSError?
}

// MARK: Testable

extension ResultActionItem: Testable {
    
    var valueToValidate: AnyObject { get { return result ?? "" } }
    var validationError: NSError? {
        get { return validate(valueToValidate) }
        set {}
    }
        
    func validate(object: AnyObject) -> NSError? {
        return validation?(object: object)
    }
}
