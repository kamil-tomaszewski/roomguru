//
//  UILabelExtensions.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit


// MARK: Factory methods

extension UILabel {
    
    class func roundedExclamationMarkLabel(frame: CGRect) -> UILabel {
        let leftViewLabel = UILabel(frame: frame)
        leftViewLabel.font = .fontAwesomeOfSize(18)
        leftViewLabel.text = .fontAwesomeIconWithName(.ExclamationCircle)
        leftViewLabel.textColor = .ngRedColor()
        leftViewLabel.textAlignment = .Center
        return leftViewLabel
    }
    
    class func calendarIconLabel() -> UILabel {
        let label = UILabel()
        label.font = .fontAwesomeOfSize(100)
        label.textAlignment = .Center
        label.textColor = .ngOrangeColor()
        label.text = .fontAwesomeIconWithName(.CalendarO)
        return label
    }
}
