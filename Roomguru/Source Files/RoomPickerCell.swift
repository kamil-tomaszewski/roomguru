//
//  RoomPickerCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class RoomPickerCell: UICollectionViewCell, Reusable {
    
    class func reuseIdentifier() -> String {
        return "UICollectionViewRoomPickerCellReuseIdentifier"
    }
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension RoomPickerCell {
    
    func commonInit() {
        
        backgroundColor = UIColor.whiteColor()
        
        textLabel.backgroundColor = .grayColor()
        addSubview(textLabel)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(textLabel) { label in
            label.edges == inset(label.superview!.edges, 10)
        }
    }
}
