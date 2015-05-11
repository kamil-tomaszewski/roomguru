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
    
    private static var accessoryViewFrame = CGRectMake(0, 0, 30, 30)
    
    class func reuseIdentifier() -> String {
        return "TableViewTextFieldCellReuseIdentifier"
    }
    
    let textField = TextField()
    var validationError: NSError? {
        didSet {
            let isError = (validationError != nil)
            let fontAwesome: FontAwesome = isError ? .ExclamationCircle : .CheckCircle
            let color: UIColor = isError ? .ngRedColor() : .ngGreenColor()
            updateAccessoryLabelWithFontAwesome(fontAwesome, color: color)
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
        textField.leftView = accessoryLabel()
        textField.leftViewMode = .Always
        textField.clearButtonMode = .Never
        textField.tintColor = .ngOrangeColor()
        textField.leftInset = 30
    }
    
    func accessoryLabel() -> UILabel {
        return UILabel.roundedExclamationMarkLabel(TextFieldCell.accessoryViewFrame)
    }
    
    func updateAccessoryLabelWithFontAwesome(fontAwesome: FontAwesome, color: UIColor) {
        if let label = textField.leftView as? UILabel {
            label.text = .fontAwesomeIconWithName(fontAwesome)
            label.textColor = color
        }
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
