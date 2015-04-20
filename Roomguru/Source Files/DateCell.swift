//
//  DateCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 17/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class DateCell: TableViewCell {
    
    override class var reuseIdentifier: String {
        get { return "TableViewDateCellReuseIdentifier" }
    }
    
    let dateLabel = UILabel()
    let timeLabel = UILabel()
    
    private var timeLabelConstraintGroup = ConstraintGroup()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        timeLabel.sizeToFit()
        
        constrain(timeLabel, replace: timeLabelConstraintGroup) { time in
            time.width == CGRectGetWidth(self.timeLabel.frame) + 10
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            toggleLabelsColor()
        }
    }
    
    func setSelectedLabelsColor(selected: Bool) {
        let color = selected ? UIColor.ngOrangeColor() : UIColor.blackColor()
        setLabelsColor(color)
    }
        
    // MARK: Private
    
    private func commonInit() {
        timeLabel.numberOfLines = 1
        timeLabel.textAlignment = .Center
        dateLabel.textAlignment = .Right
        
        addSubview(dateLabel)
        addSubview(timeLabel)
        
        defineConstraints()
    }
    
    private func defineConstraints() {

        let margin: CGFloat = 15
        
        timeLabelConstraintGroup = layout(timeLabel) { time in
            time.width == CGRectGetWidth(self.timeLabel.frame) + 10
        }
        
        layout(dateLabel, timeLabel) { (date, time) in
            
            time.right == time.superview!.right - margin
            time.height == 44.0

            date.right == time.left - margin
            date.left == date.superview!.left
            date.height == time.height
        }
    }
    
    private func toggleLabelsColor() {
        let blackColor = UIColor.blackColor()
        let color = dateLabel.textColor == blackColor ? UIColor.ngOrangeColor() : blackColor
        setLabelsColor(color)
    }
    
    private func setLabelsColor(color: UIColor) {
        dateLabel.textColor = color
        timeLabel.textColor = color
    }
}
