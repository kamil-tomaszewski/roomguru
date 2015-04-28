//
//  DatePickerCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 18/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class DatePickerCell: UITableViewCell, Reusable {
    
    class func reuseIdentifier() -> String {
        return "TableViewDatePickerCellReuseIdentifier"
    }
    
    let datePicker = UIDatePicker()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension DatePickerCell {
    
    func commonInit() {
        datePicker.datePickerMode = .DateAndTime
        addSubview(datePicker)
        defineConstraints()
    }
    
    func defineConstraints() {
        
        let width = CGRectGetWidth(self.frame)
        self.frame = CGRectMake(0, 0, width, 160.0)
        
        layout(datePicker) { picker in
            picker.edges == picker.superview!.edges
            picker.height == 160
        }
    }
}
