//
//  DateItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 17/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DateItem: GroupItem {

    var date: NSDate
    var dateString: String { get { return dateFormatter.stringFromDate(date) } }

    var validation: DateValidationBlock?
    var onValueChanged: DateBlock?
    
    var highlighted = false
    
    init(title: String, date: NSDate = NSDate()) {
        self.date = date
        
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle

        super.init(title: title, category: .Date)
    }
    
    private let dateFormatter = NSDateFormatter()
}

// MARK: Updatable

extension DateItem: Updatable {
    
    func update() {
        onValueChanged?(date: date)
    }
}

// MARK: Testable

extension DateItem: Validatable {
    
    var valueToValidate: AnyObject { return date }
    
    var validationError: NSError? {
        return validate(valueToValidate)
    }
    
    func validate(object: AnyObject) -> NSError? {
        if let date = object as? NSDate {
            return validation?(date: date)
        }
        return nil
    }
}
