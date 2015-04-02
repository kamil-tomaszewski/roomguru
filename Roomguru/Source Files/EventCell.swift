//
//  EventCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 24/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class EventCell: UITableViewCell {
    
    let timeMaxLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 65, 25))
    let timeMinLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 65, 25))
    
    private struct constants { static var cellIdentifier: String = "TableViewEventCellReuseIdentifier"}
    
    class var reuseIdentifier: String {
        get { return constants.cellIdentifier }
        set { constants.cellIdentifier = newValue }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Private
    
    private func commonInit() {
        configure()
        contentView.addSubview(timeMaxLabel)
        contentView.addSubview(timeMinLabel)
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(timeMaxLabel, timeMinLabel) { upperLabel, lowerLabel in
            upperLabel.top >= upperLabel.superview!.top + 15
            upperLabel.left == upperLabel.superview!.left + 10
            
            lowerLabel.bottom >= lowerLabel.superview!.bottom - 15
            lowerLabel.left == lowerLabel.superview!.left + 10
            lowerLabel.width == upperLabel.width
            lowerLabel.height == upperLabel.height
        }
    }
    
    private func configure() {
        let font = UIFont.boldSystemFontOfSize(13.0)
        
        timeMaxLabel.font = font
        timeMinLabel.font = font
    }
}
