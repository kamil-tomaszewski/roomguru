//
//  TextField.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 28/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class TextField: UITextField {
    var leftInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , leftInset , rightInset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , leftInset , rightInset)
    }
}
