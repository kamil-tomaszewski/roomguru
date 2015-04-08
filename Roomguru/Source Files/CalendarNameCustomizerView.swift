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
        
        addSubview(textField)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
        layout(textField) { textField in
            
            let margin: CGFloat = 20
            
            textField.left == textField.superview!.left + margin
            textField.right == textField.superview!.right - margin
            textField.top == textField.superview!.top + 120
            textField.height == 44
        }
    }

}
