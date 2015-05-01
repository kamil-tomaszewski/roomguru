//
//  EventCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 24/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class EventCell: UITableViewCell, Reusable {
    
    let timeMaxLabel = UILabel()
    let timeMinLabel = UILabel()
    
    class func reuseIdentifier() -> String {
        return "TableViewEventCellReuseIdentifier"
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsetsZero
        
        indentationLevel = 8
        
        timeMaxLabel.font = .boldSystemFontOfSize(13.0)
        contentView.addSubview(timeMaxLabel)
        
        timeMinLabel.font = .boldSystemFontOfSize(13.0)
        contentView.addSubview(timeMinLabel)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(timeMinLabel, timeMaxLabel) { upperLabel, lowerLabel in
            
            upperLabel.left == upperLabel.superview!.left + 10
            upperLabel.bottom == upperLabel.superview!.centerY
            upperLabel.height == 20
            
            lowerLabel.left == upperLabel.left
            lowerLabel.top == lowerLabel.superview!.centerY
            lowerLabel.height == upperLabel.height
        }
    }
}
