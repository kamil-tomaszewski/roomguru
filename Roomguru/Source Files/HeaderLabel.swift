//
//  HeaderLabel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 31/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class HeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsetsMake(0, 15, 0, 0)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    // MARK: Private
    
    private func commonInit() {
        backgroundColor = UIColor.ngGrayColor()
        textColor = UIColor.ngOrangeColor()
        font = UIFont.boldSystemFontOfSize(16)
    }
}
