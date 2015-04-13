//
//  RoundBorderedImageView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 14/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class RoundBorderedImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        contentMode = .ScaleAspectFit
        layer.masksToBounds = true
        layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5
        layer.borderWidth = 4
        layer.borderColor = UIColor.whiteColor().CGColor
    }
}
