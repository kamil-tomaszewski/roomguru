//
//  DayCarouselCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 28/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

enum DayCellStyle {
    case Today, Selected, Normal, Past
}

class DayCarouselCell: UICollectionViewCell, Reusable {
    
    class var reuseIdentifier: String {
        return "UICollectionViewDayCarouselCellReuseIdentifier"
    }
    
    let textLabel = UILabel(frame: CGRectMake(0, 0, 36, 36))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func setAppearanceWithStyle(style: DayCellStyle) {
        
        switch style {
        case .Today:
            customizeTextLabelWithColors(backgroundColor: .whiteColor(), textColor: .ngOrangeColor(), bold: true)
        case .Selected:
            customizeTextLabelWithColors(backgroundColor: .ngOrangeColor(), textColor: .whiteColor())
        case .Normal:
            customizeTextLabelWithColors(backgroundColor: .whiteColor(), textColor: .ngGrayColor())
        case .Past:
            customizeTextLabelWithColors(backgroundColor: .whiteColor(), textColor: .rgb(210, 210, 210))
        }
    }
}

private extension DayCarouselCell {
    
    func commonInit() {
        
        backgroundColor = UIColor.clearColor()
        
        textLabel.layer.masksToBounds = true
        textLabel.layer.borderWidth = 1
        textLabel.layer.borderColor = UIColor.clearColor().CGColor
        textLabel.layer.cornerRadius = CGRectGetMidY(textLabel.frame)
        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(textLabel) { label in
            label.center == label.superview!.center
            label.width == CGRectGetWidth(self.textLabel.frame)
            label.height == CGRectGetHeight(self.textLabel.frame)
        }
    }
    
    func customizeTextLabelWithColors(#backgroundColor: UIColor, textColor: UIColor, bold: Bool = false) {
        
        textLabel.font = bold ? .boldSystemFontOfSize(17) : .systemFontOfSize(17)
        textLabel.textColor = textColor
        textLabel.backgroundColor = backgroundColor
    }
}
