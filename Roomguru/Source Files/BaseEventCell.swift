//
//  BaseEventCell.swift
//  Roomguru
//
//  Created by Kamil Tomaszewski on 10/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class BaseEventCell: UITableViewCell {
    
    let timeMaxLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 65, 25))
    let timeMinLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 65, 25))

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func defineConstraints() {
        
        layout(timeMaxLabel, timeMinLabel) { upperLabel, lowerLabel in
            upperLabel.top >= upperLabel.superview!.top + 15
            upperLabel.left == upperLabel.superview!.left + 10
            
            lowerLabel.bottom >= lowerLabel.superview!.bottom - 15
            lowerLabel.left == lowerLabel.superview!.left + 10
            lowerLabel.width == upperLabel.width
            lowerLabel.height == upperLabel.height
        }
    }
}
