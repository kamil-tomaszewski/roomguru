//
//  CalendarPickerCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 07/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class CalendarPickerCell: UITableViewCell, Reusable {
    
    let checkmarkLabel = UILabel()
    let headerLabel = UILabel()
    let footerLabel = UILabel()
    
    class func reuseIdentifier() -> String {
        return "TableViewCalendarPickerCellReuseIdentifier"
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension CalendarPickerCell {

    func commonInit() {
        
        tintColor = .ngOrangeColor()
        accessoryType = .DetailButton
        
        checkmarkLabel.font = .fontAwesomeOfSize(18)
        checkmarkLabel.text = String.fontAwesomeIconWithName(.Check)
        checkmarkLabel.textColor = .ngOrangeColor()
        checkmarkLabel.textAlignment = .Center
        contentView.addSubview(checkmarkLabel)
        
        headerLabel.font = .systemFontOfSize(16)
        contentView.addSubview(headerLabel)
        
        footerLabel.textColor = .darkGrayColor()
        footerLabel.font = .systemFontOfSize(12)
        contentView.addSubview(footerLabel)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(checkmarkLabel, headerLabel, footerLabel) { leftLabel, topLabel, bottomLabel in
            
            let margin: CGFloat = 10
            
            leftLabel.top == leftLabel.superview!.top + margin
            leftLabel.bottom == leftLabel.superview!.bottom - margin
            leftLabel.left == leftLabel.superview!.left + margin
            leftLabel.width == 30
            
            topLabel.left == leftLabel.right
            topLabel.top == leftLabel.top
            topLabel.bottom == topLabel.superview!.centerY
            topLabel.right == topLabel.superview!.right - 40
            
            bottomLabel.left == topLabel.left
            bottomLabel.top == topLabel.bottom
            bottomLabel.height == topLabel.height
            bottomLabel.width == topLabel.width
        }
    }
}
