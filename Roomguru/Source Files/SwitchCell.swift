//
//  SwitchCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class SwitchCell: UITableViewCell, Reusable {
    
    class var reuseIdentifier: String {
        return "TableViewSwitchCellReuseIdentifier"
    }
    
    let switchControl = UISwitch()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension SwitchCell {
    
    func commonInit() {
        
        switchControl.onTintColor = UIColor.ngOrangeColor()
        contentView.addSubview(switchControl)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(switchControl) { aSwitch in 
            aSwitch.centerY == aSwitch.superview!.centerY
            aSwitch.right == aSwitch.superview!.right - 20
        }
    }
}
