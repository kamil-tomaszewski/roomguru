//
//  EventCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 24/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

enum EventCellDisplayStyle {
    case Past, Current, Future
    
    func color() -> (backgroundColor: UIColor, textColor: UIColor) {
        switch self {
        case .Past:
            return (.rgb(235, 235, 235), .lightGrayColor())
        case .Current, .Future:
            return (.whiteColor(), .blackColor())
        }
    }
}

class EventCell: UITableViewCell, Reusable {
    
    let timeMaxLabel = UILabel()
    let timeMinLabel = UILabel()
    let ongoingBadge = UILabel()
    
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
        
        ongoingBadge.textColor = UIColor.ngRedColor()
        ongoingBadge.text = NSLocalizedString("Ongoing", comment: "")
        ongoingBadge.font = .systemFontOfSize(13)
        ongoingBadge.textAlignment = .Right
        contentView.addSubview(ongoingBadge)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(timeMinLabel, timeMaxLabel, ongoingBadge) { upperLabel, lowerLabel, badge in
            
            upperLabel.left == upperLabel.superview!.left + 10
            upperLabel.bottom == upperLabel.superview!.centerY
            upperLabel.height == 20
            
            lowerLabel.left == upperLabel.left
            lowerLabel.top == lowerLabel.superview!.centerY
            lowerLabel.height == upperLabel.height
            
            badge.height == 30
            badge.right == badge.superview!.right - 4
            badge.top == badge.superview!.top - 4
        }
    }
    
    func setStyle(style: EventCellDisplayStyle) {
        
        let styleColors = style.color()
        
        contentView.backgroundColor = styleColors.backgroundColor
        timeMaxLabel.textColor = styleColors.textColor
        timeMinLabel.textColor = styleColors.textColor
        textLabel?.textColor = styleColors.textColor
    }
}
