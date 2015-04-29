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
        leftViewLabel.font = UIFont.fontAwesomeOfSize(18)
        leftViewLabel.text = String.fontAwesomeIconWithName(.ExclamationCircle)
        leftViewLabel.textColor = UIColor.ngRedColor()
        leftViewLabel.textAlignment = .Center
        return leftViewLabel
    }
}
