//
//  DateItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 17/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DateItem: GroupItem {

    var date: NSDate {
        didSet { validationError = nil }
    }
    
    var dateString: String { get { return dateFormatter.stringFromDate(date) } }

    var validation: DateValidationBlock?
    var onValueChanged: DateBlock?
    
    init(title: String, date: NSDate = NSDate()) {
        self.date = date
        
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle

        super.init(title: title, category: .Date)
    }
    
    private var _validationError: NSError?
    private let dateFormatter = NSDateFormatter()
}

// MARK: Updatable

extension DateItem: Updatable {
    
    func update() {
        onValueChanged?(date: date)
    }
}

// MARK: Testable

extension DateItem: Testable {
    
    var valueToValidate: AnyObject { get { return date } }
    
    var validationError: NSError? {
        get { return _validationError }
        set { _validationError = newValue }
    }
    
    func validate(object: AnyObject) -> NSError? {
        if let date = object as? NSDate {
            return validation?(date: date)
        }
        return nil
    }
}
