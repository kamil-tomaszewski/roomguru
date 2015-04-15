//
//  RoomguruLabel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class RoomguruLabel: UILabel {

    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        text = NSLocalizedString("Roomguru", comment: "")
        font = UIFont(name: "BradleyHandITCTT-Bold", size: 36)
        textAlignment = .Center
        textColor = UIColor.ngOrangeColor()
    }
}
