//
//  BorderTextField.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 07/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class BorderTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        clearButtonMode = .WhileEditing
        autocorrectionType = .No
        autocapitalizationType = .None
        tintColor = UIColor.ngGrayColor()
        
        layer.borderColor = UIColor.ngOrangeColor().CGColor
        layer.borderWidth = 1
        layer.cornerRadius = 3
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0);
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0);
    }
}
