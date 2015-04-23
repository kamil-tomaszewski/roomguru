//
//  PickerItemCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class PickerItemCell: UITableViewCell, Reusable {
    
    let checkmarkLabel = UILabel()
    
    class func reuseIdentifier() -> String {
        return "TableViewPickerItemCellReuseIdentifier"
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
        configure()
        contentView.addSubview(checkmarkLabel)
        defineConstraints()
    }
    
    private func configure() {
        indentationLevel = 3
        tintColor = UIColor.ngOrangeColor()
        checkmarkLabel.font = UIFont.fontAwesomeOfSize(18)
        checkmarkLabel.text = String.fontAwesomeIconWithName(.Check)
        checkmarkLabel.textColor = UIColor.ngOrangeColor()
        checkmarkLabel.textAlignment = .Center
    }
    
    private func defineConstraints() {
        
        layout(checkmarkLabel) { checkmark in
            
            let margin: CGFloat = 10
            
            checkmark.top == checkmark.superview!.top + margin
            checkmark.bottom == checkmark.superview!.bottom - margin
            checkmark.left == checkmark.superview!.left + margin
            checkmark.width == 30
        }
    }
}
