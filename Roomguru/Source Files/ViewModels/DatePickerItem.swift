//
//  DatePickerItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 18/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Async

class DatePickerItem: GroupItem {
    
    var date: NSDate
    var onValueChanged: DateBlock
    private weak var datePicker: UIDatePicker?
    
    init(date: NSDate, onValueChanged: DateBlock) {
        self.date = date
        self.onValueChanged = onValueChanged
        super.init(title: "", category: .Picker)
    }
    
    func bindDatePicker(datePicker: UIDatePicker) {
        self.datePicker = datePicker
        Async.main { datePicker.setDate(self.date, animated: false) }
        datePicker.addTarget(self, action: "didChangeDate:forEvents:", forControlEvents: .ValueChanged)
    }
    
    func unbindDatePicker() {
        self.datePicker?.removeTarget(self, action: "didChangeDate:forEvents:", forControlEvents: .ValueChanged)
    }
    
    func didChangeDate(sender: UIDatePicker, forEvents events: UIControlEvents) {
        date = sender.date
        onValueChanged(date: date)
    }
}
