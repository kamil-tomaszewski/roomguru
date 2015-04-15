//
//  CalendarNameCustomizerView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 07/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class CalendarNameCustomizerView: UIView {
    
    let textField = BorderTextField()
    let button: UIButton = UIButton.buttonWithType(.System) as! UIButton
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.whiteColor()
        
        button.backgroundColor = UIColor.ngOrangeColor()
        button.setTitle(NSLocalizedString("Bring back original name", comment: ""))
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.layer.cornerRadius = 3
        addSubview(button)
        
        textField.returnKeyType = .Done
        addSubview(textField)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
        layout(textField, button) { textField, button in
            
            let margin: CGFloat = 20
            
            textField.left == textField.superview!.left + margin
            textField.right == textField.superview!.right - margin
            textField.top == textField.superview!.top + 120
            textField.height == 44
            
            button.top == textField.bottom + 20
            button.left == textField.left
            button.width == textField.width
            button.height == 44
        }
    }

}
