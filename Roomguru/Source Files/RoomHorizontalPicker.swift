//
//  RoomHorizontalPicker.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import AKPickerView_Swift

class RoomHorizontalPicker: AKPickerView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension RoomHorizontalPicker {
    
    func commonInit() {
                
        font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        highlightedFont = UIFont(name: "HelveticaNeue", size: 20)!
        interitemSpacing = 20.0
        viewDepth = 2000.0
        textColor = .ngOrangeColor()
        highlightedTextColor = .ngOrangeColor()
        maskDisabled = false
        reloadData()
    }
}
