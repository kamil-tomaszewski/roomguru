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
    let colorView = UIView()
    
    class var reuseIdentifier: String {
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
        
        lengthenSeparatorLine()
        
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
        
        colorView.backgroundColor = UIColor.clearColor()
        contentView.addSubview(colorView)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(timeMinLabel, timeMaxLabel, ongoingBadge) { upperLabel, lowerLabel, badge in
            
            upperLabel.left == upperLabel.superview!.left + 10
            upperLabel.bottom == upperLabel.superview!.centerY
            upperLabel.height == 20
            upperLabel.width == 60
            
            lowerLabel.left == upperLabel.left
            lowerLabel.top == lowerLabel.superview!.centerY
            lowerLabel.height == upperLabel.height
            lowerLabel.width == 60
            
            badge.height == 30
            badge.right == badge.superview!.right - 4
            badge.top == badge.superview!.top - 4
        }
        
        layout(colorView) { color in
            color.left == color.superview!.left
            color.top == color.superview!.top
            color.bottom == color.superview!.bottom
            color.width == 4
        }
    }
    
    func setStyle(style: EventCellDisplayStyle) {
        
        let styleColors = style.color()
        
        contentView.backgroundColor = styleColors.backgroundColor
        timeMaxLabel.textColor = styleColors.textColor
        timeMinLabel.textColor = styleColors.textColor
        textLabel?.textColor = styleColors.textColor
        
        ongoingBadge.hidden = (style != .Current)
    }
}
