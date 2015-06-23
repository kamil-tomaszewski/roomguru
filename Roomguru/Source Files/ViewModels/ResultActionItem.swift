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

extension ResultActionItem: Validatable {
    
    var valueToValidate: AnyObject { return result ?? "" }
    var validationError: NSError? {
        return validate(valueToValidate)
    }
        
    func validate(object: AnyObject) -> NSError? {
        return validation?(object: object)
    }
}
