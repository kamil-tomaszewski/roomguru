//
//  TextFieldCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 16/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class TextFieldCell: TableViewCell {
    
    override class var reuseIdentifier: String {
        get { return "TableViewTextFieldCellReuseIdentifier" }
    }
    
    let textField = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        textField.tintColor = UIColor.ngOrangeColor()
        addSubview(textField)
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(textField) { (field) in
            
            let margin: CGFloat = 15
            
            field.centerX == field.superview!.centerX
            field.centerY == field.superview!.centerY
            field.width == field.superview!.width - (2 * margin)
            field.height == 44.0
        }
    }
}
