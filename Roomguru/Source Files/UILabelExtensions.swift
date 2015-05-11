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
        return fontAwesomeLabelWithFrame(frame, fontSize: 18, fontAwesome: .ExclamationCircle, color: UIColor.ngRedColor())
    }
    
    class func fontAwesomeLabelWithFrame(frame: CGRect, fontSize size: CGFloat, fontAwesome: FontAwesome, color: UIColor) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = .fontAwesomeOfSize(size)
        label.text = .fontAwesomeIconWithName(fontAwesome)
        label.textColor = color
        label.textAlignment = .Center
        return label
    }
    
    class func fontAwesomeLabel() -> UILabel {
        let label = UILabel()
        label.font = .fontAwesomeOfSize(100)
        label.textAlignment = .Center
        label.textColor = .ngOrangeColor()
        return label
    }
}
