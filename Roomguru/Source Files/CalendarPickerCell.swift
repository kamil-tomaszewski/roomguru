//
//  CalendarPickerCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class CalendarPickerCell: UITableViewCell {
    
    let headerLabel = UILabel()
    let footerLabel = UILabel()
    
    private struct Constants { static var CellIdentifier: String = "TableViewCalendarPickerCellReuseIdentifier"}
    
    class var reuseIdentifier: String {
        get { return Constants.CellIdentifier }
        set { Constants.CellIdentifier = newValue }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: Private
    
    private func commonInit() {
        
       
        
        headerLabel.font = UIFont.systemFontOfSize(16)
        contentView.addSubview(headerLabel)
        
        footerLabel.textColor = UIColor.darkGrayColor()
        footerLabel.font = UIFont.systemFontOfSize(12)
        contentView.addSubview(footerLabel)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(headerLabel, footerLabel) { topLabel, bottomLabel in
            
            let margins: (H: CGFloat, V: CGFloat) = (15, 10)
            
            topLabel.top == topLabel.superview!.top + margins.V
            topLabel.left == topLabel.superview!.left + margins.H
            topLabel.right == topLabel.superview!.right - 50
            topLabel.bottom == topLabel.superview!.centerY
            
            bottomLabel.top == topLabel.bottom
            bottomLabel.left == topLabel.left
            bottomLabel.right == topLabel.right
            bottomLabel.height == topLabel.height
        }
    }

}
