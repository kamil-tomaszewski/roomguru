//
//  TextFieldCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 16/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class TextFieldCell: UITableViewCell, Reusable {
    
    class func reuseIdentifier() -> String {
        return "TableViewTextFieldCellReuseIdentifier"
    }
    
    let textField = UITextField()
    var validationError: NSError? {
        didSet {
            if validationError != nil {
                textField.rightViewMode = .Always
                textField.clearButtonMode = .WhileEditing
            } else {
                textField.rightViewMode = .Never
                textField.clearButtonMode = .Never
            }
        }
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
        configureTextField(textField)
        addSubview(textField)
        defineConstraints()
    }
    
    private func configureTextField(textField: UITextField) {
        textField.rightView = rightViewForTextField()
        textField.rightViewMode = .Always
        textField.clearButtonMode = .Never
        textField.tintColor = UIColor.ngOrangeColor()
    }
    
    private func rightViewForTextField() -> UIView {
        let rightViewFrame = CGRectMake(0, 0, 30, 30)
        let rightViewLabel = UILabel(frame: rightViewFrame)
        rightViewLabel.font = UIFont.fontAwesomeOfSize(18)
        rightViewLabel.text = String.fontAwesomeIconWithName(.ExclamationCircle)
        rightViewLabel.textColor = UIColor.ngRedColor()
        rightViewLabel.textAlignment = .Center
        return rightViewLabel
    }
    
    private func defineConstraints() {
        
        layout(textField) { field in
            
            let margin: CGFloat = 15
            
            field.centerX == field.superview!.centerX
            field.centerY == field.superview!.centerY
            field.width == field.superview!.width - (2 * margin)
            field.height == 44.0
        }
    }
}
