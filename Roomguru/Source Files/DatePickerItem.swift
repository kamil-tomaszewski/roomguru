//
//  DatePickerItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 18/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

class DatePickerItem: GroupItem {
    
    var date: NSDate
    var validationError: NSError?
    var onValueChanged: DateValidationBlock
    
    init(date: NSDate, onValueChanged: DateValidationBlock) {
        self.date = date
        self.onValueChanged = onValueChanged
        super.init(title: "", category: .Picker)
    }
    
    func bindDatePicker(datePicker: UIDatePicker) {
        datePicker.addTarget(self, action: "didChangeDate:forEvents:", forControlEvents: .ValueChanged)
    }
    
    func unbindDatePicker(datePicker: UIDatePicker) {
        datePicker.removeTarget(self, action: "didChangeDate:forEvents:", forControlEvents: .ValueChanged)
    }
    
    func didChangeDate(sender: UIDatePicker, forEvents events: UIControlEvents) {
        validationError = onValueChanged(date: sender.date)
        
        if let validationError = validationError {
            sender.setDate(date, animated: true)
        } else {
            date = sender.date
        }
    }
}
