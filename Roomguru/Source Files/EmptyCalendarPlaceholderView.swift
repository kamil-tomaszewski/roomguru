//
//  EmptyCalendarPlaceholderView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class EmptyCalendarPlaceholderView: UIView {
    
    private let placeholderIconLabel = UILabel()
    private let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension EmptyCalendarPlaceholderView {
    
    func commonInit() {
        
        backgroundColor = .whiteColor()
        
        placeholderIconLabel.font = UIFont.fontAwesomeOfSize(100)
        placeholderIconLabel.textAlignment = .Center
        placeholderIconLabel.textColor = .ngOrangeColor()
        placeholderIconLabel.text = String.fontAwesomeIconWithName(.CalendarO)
        addSubview(placeholderIconLabel)

        infoLabel.textColor = .ngGrayColor()
        infoLabel.font = .systemFontOfSize(16)
        infoLabel.text = NSLocalizedString("No calendars selected.\nTo select calendars go to \"Settings\" -> \"Manage Calendars\".", comment: "")
        infoLabel.textAlignment = .Center
        infoLabel.numberOfLines = 0
        addSubview(infoLabel)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(placeholderIconLabel, infoLabel) { placeholder, info in
            
            placeholder.centerX == placeholder.superview!.centerX
            placeholder.height == 100
            placeholder.width == 100
            placeholder.bottom == placeholder.superview!.centerY
            
            info.top == info.superview!.centerY
            info.centerX == info.superview!.centerX
            info.width == info.superview!.width - 40
            info.bottom == info.superview!.bottom
        }
    }
    
}
