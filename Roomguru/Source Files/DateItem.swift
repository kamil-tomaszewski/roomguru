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
    
    init(title: String, date: NSDate = NSDate()) {
        self.date = date
        
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle

        super.init(title: title, category: .Date)
    }
    
    func validate(date: NSDate) -> NSError? {
        return validation?(date: date)
    }
    
    private let dateFormatter = NSDateFormatter()
}

// MARK: Updatable

extension DateItem: Updatable {
    
    func update() {
        onValueChanged?(date: date)
    }
}
