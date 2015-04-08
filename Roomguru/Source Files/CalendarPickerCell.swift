//
//  CalendarPickerCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 07/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class CalendarPickerCell: UITableViewCell {
    
    let checkmarkLabel = UILabel()
    let headerLabel = UILabel()
    let footerLabel = UILabel()
    
    private struct constants { static var cellIdentifier: String = "TableViewCalendarPickerCellReuseIdentifier"}
    
    class var reuseIdentifier: String {
        get { return constants.cellIdentifier }
        set { constants.cellIdentifier = newValue }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        tintColor = UIColor.ngOrangeColor()
        accessoryType = .DetailButton
        
        checkmarkLabel.font = UIFont.fontAwesomeOfSize(18)
        checkmarkLabel.text = String.fontAwesomeIconWithName(.Check)
        checkmarkLabel.textColor = UIColor.ngOrangeColor()
        checkmarkLabel.textAlignment = .Center
        contentView.addSubview(checkmarkLabel)
        
        headerLabel.font = UIFont.systemFontOfSize(16)
        contentView.addSubview(headerLabel)
        
        footerLabel.textColor = UIColor.darkGrayColor()
        footerLabel.font = UIFont.systemFontOfSize(12)
        contentView.addSubview(footerLabel)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(checkmarkLabel, headerLabel, footerLabel) { (leftLabel, topLabel, bottomLabel) in
            
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
