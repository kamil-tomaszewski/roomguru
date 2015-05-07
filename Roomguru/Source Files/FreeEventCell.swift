//
//  FreeEventCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 24/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography
import Async

enum FreeEventCellState {
    case Normal, Tapped
}

class FreeEventCell: EventCell {
    
    let bookButton = UIButton.buttonWithType(.System) as! UIButton
    let timeLabel = UILabel()
    
    private var cellState: FreeEventCellState = .Normal
    
    override class func reuseIdentifier() -> String {
        return "TableViewFreeEventCellReuseIdentifier"
    }

    override func commonInit() {
        
        bookButton.titleLabel?.font = .boldSystemFontOfSize(17.0)
        bookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        bookButton.setTitle("Book now!")
        contentView.addSubview(bookButton)
        
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.textAlignment = .Center
        contentView.addSubview(timeLabel)

        super.commonInit()
        
        contentView.backgroundColor = UIColor.ngOrangeColor()
        
        
    }
    
    override func defineConstraints() {
        super.defineConstraints()
        
        layout(timeMaxLabel, bookButton, timeLabel) { maxLabel, button, label in
            
            button.right == button.superview!.right - 5
            button.centerY == button.superview!.centerY
            button.width == 100
            button.height == 40
            
            label.left == maxLabel.right
            label.top == label.superview!.top
            label.bottom == label.superview!.bottom
            label.right == button.left
        }
    }
}
