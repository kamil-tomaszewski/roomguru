//
//  RightDetailTextCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 19/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class RightDetailTextCell: UITableViewCell, Reusable {
    
    class func reuseIdentifier() -> String {
        return "TableViewRightDetailTextCellReuseIdentifier"
    }
    
    let detailLabel = UILabel()
    
    private var leftAccessoryLabel = UILabel()
    
    var validationError: NSError? {
        didSet {
            if validationError != nil {
                leftAccessoryLabel.hidden = false
                indentationLevel = 3
            } else {
                leftAccessoryLabel.hidden = true
                indentationLevel = 0
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        leftAccessoryLabel = accessoryLabel()
        detailLabel.textAlignment = .Right
        addSubview(detailLabel)
        addSubview(leftAccessoryLabel)
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(detailLabel) { detail in
            detail.right == detail.superview!.right - 35
            detail.width == CGRectGetWidth(self.frame) * 0.6
            detail.centerY == detail.superview!.centerY
        }
        
        layout(leftAccessoryLabel) { accessory in
            accessory.left == accessory.superview!.left + 10
            accessory.centerY == accessory.superview!.centerY
            accessory.width == 30
            accessory.height == 30
        }
    }
    
    private func accessoryLabel() -> UILabel {
        let accessoryViewFrame = CGRectMake(0, 0, 30, 30)
        let accessoryViewLabel = UILabel(frame: accessoryViewFrame)
        accessoryViewLabel.font = UIFont.fontAwesomeOfSize(18)
        accessoryViewLabel.text = String.fontAwesomeIconWithName(.ExclamationCircle)
        accessoryViewLabel.textColor = UIColor.ngRedColor()
        accessoryViewLabel.textAlignment = .Center
        accessoryViewLabel.hidden = true
        return accessoryViewLabel
    }
}
