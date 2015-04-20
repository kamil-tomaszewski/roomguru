//
//  TextItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 17/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

class TextItem: GroupItem {
    var placeholder: String
    var onValueChanged: StringBlock
    
    init(title: String, placeholder: String, text: String, onValueChanged: StringBlock) {
        self.placeholder = placeholder
        self.onValueChanged = onValueChanged
        self.text = text
        super.init(title: title, category: .PlainText)
    }
    
    private var text: String
}

extension TextItem: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        text = textField.text
        onValueChanged(text: text)
    }
}

// MARK: Updatable

extension TextItem: Updatable {
    
    func update() {
        onValueChanged(text: text)
    }
}
