//
//  GroupItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 17/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol Updatable {
    func update()
}

protocol Validatable {
    var valueToValidate: AnyObject { get }
    var validationError: NSError? { get set }
    func validate(object: AnyObject) -> NSError?
}

class GroupItem: NSObject {
    
    enum Category {
        case Action, PlainText, LongText, Date, Picker, Boolean
    }
    
    let title: String
    let category: Category
    var active = true
    
    init(title: String, category: Category) {
        self.title = title
        self.category = category
    }
}
