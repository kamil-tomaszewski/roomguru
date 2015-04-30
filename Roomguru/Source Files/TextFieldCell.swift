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
    
    let textField = TextField()
    var validationError: NSError? {
        didSet {
            if validationError != nil {
                textField.leftViewMode = .Always
                textField.clearButtonMode = .WhileEditing
                textField.leftInset = 30
            } else {
                textField.leftViewMode = .Never
                textField.clearButtonMode = .Never
                textField.leftInset = 5
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
}

private extension TextFieldCell {
    
    func commonInit() {
        configureTextField(textField)
        contentView.addSubview(textField)
        
        defineConstraints()
    }
    
    func configureTextField(textField: TextField) {
        textField.leftView = UILabel.roundedExclamationMarkLabel(CGRectMake(0, 0, 30, 30))
        textField.leftViewMode = .Always
        textField.clearButtonMode = .Never
        textField.tintColor = .ngOrangeColor()
    }
    
    func leftViewForTextField() -> UIView {
        let leftViewFrame = CGRectMake(0, 0, 30, 30)
        let leftViewLabel = UILabel(frame: leftViewFrame)
        leftViewLabel.font = UIFont.fontAwesomeOfSize(18)
        leftViewLabel.text = String.fontAwesomeIconWithName(.ExclamationCircle)
        leftViewLabel.textColor = UIColor.ngRedColor()
        leftViewLabel.textAlignment = .Center
        return leftViewLabel
    }
    
    func defineConstraints() {
        
        layout(textField) { field in
            
            let margin: CGFloat = 10
            
            field.centerX == field.superview!.centerX
            field.centerY == field.superview!.centerY
            field.width == field.superview!.width - (2 * margin)
            field.height == 44.0
        }
    }
}
