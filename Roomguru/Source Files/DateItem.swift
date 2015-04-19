//
//  DateItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 17/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

class DateItem: GroupItem {

    var date: NSDate {
        get { return _date }
        set {
            _date = newValue
            onValueChanged?(date: newValue)
        }
    }
    
    var timeString: String { get { return timeFormatter.stringFromDate(date) } }
    var dateString: String { get { return dateFormatter.stringFromDate(date) } }

    var validation: DateValidationBlock?
    var onValueChanged: DateBlock?
    
    init(title: String, date: NSDate = NSDate()) {
        _date = date
        
        timeFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle

        super.init(title: title, category: .Date)
    }
    
    func validate(date: NSDate) -> NSError? {
        return validation?(date: date)
    }
    
    private var _date: NSDate
    private let timeFormatter = NSDateFormatter()
    private let dateFormatter = NSDateFormatter()
}

// MARK: Updateable

extension DateItem: Updateable {
    
    func update() {
        onValueChanged?(date: _date)
    }
}
