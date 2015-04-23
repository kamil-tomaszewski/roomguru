//
//  TextItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 17/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class TextItem: GroupItem {
    
    var placeholder: String
    var onValueChanged: StringBlock?
    var validation: StringValidationBlock?
    var text: String
    
    init(title: String = "", placeholder: String, text: String = "") {
        self.placeholder = placeholder
        self.text = text
        super.init(title: title, category: .PlainText)
    }
    
    private var _validationError: NSError?
}

extension TextItem: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        text = textField.text
        onValueChanged?(string: text)
    }
}

// MARK: Updatable

extension TextItem: Updatable {
    
    func update() {
        onValueChanged?(string: text)
    }
}

// MARK: Testable 

extension TextItem: Testable {
    
    var valueToValidate: AnyObject { get { return text } }
    var validationError: NSError? {
        get { return _validationError }
        set { _validationError = newValue }
    }
    
    func validate(object: AnyObject) -> NSError? {
        if let text = object as? String {
            return validation?(string: text)
        }
        return nil
    }
}
