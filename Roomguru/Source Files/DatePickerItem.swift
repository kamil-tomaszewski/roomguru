//
//  DatePickerItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 18/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DatePickerItem: GroupItem {
    
    var date: NSDate
    var onValueChanged: DateBlock
    
    init(date: NSDate, onValueChanged: DateBlock) {
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
        date = sender.date
        onValueChanged(date: date)
    }
}
