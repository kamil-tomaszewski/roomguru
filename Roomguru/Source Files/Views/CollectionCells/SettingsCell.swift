//
//  SettingsCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class SettingsCell: UICollectionViewCell, Reusable {
    
    class var reuseIdentifier: String {
        return "UICollectionViewSettingsCellReuseIdentifier"
    }

    let textLabel = UILabel()
    let switchControl = UISwitch()
    private let line = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension SettingsCell {
    
    func commonInit() {
        
        backgroundColor = UIColor.whiteColor()
        
        line.backgroundColor = UIColor.rgb(200, 200, 200)
        contentView.addSubview(line)
        
        switchControl.onTintColor = UIColor.ngOrangeColor()
        contentView.addSubview(switchControl)
        
        contentView.addSubview(textLabel)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(textLabel, line, switchControl) { label, line, aSwitch in
            
            line.height == 1
            line.width == line.superview!.width
            line.left == line.superview!.left
            line.bottom == line.superview!.bottom
            
            aSwitch.centerY == aSwitch.superview!.centerY
            aSwitch.right == aSwitch.superview!.right - 20
            
            label.left == label.superview!.left + 10
            label.right == aSwitch.left - 10
            label.top == label.superview!.top + 10
            label.bottom == label.superview!.bottom - 10
        }
    }
}
