//
//  DayCarouselCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 28/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class DayCarouselCell: UICollectionViewCell, Reusable {
    
    class func reuseIdentifier() -> String {
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
}

private extension DayCarouselCell {
    
    func commonInit() {
        
        backgroundColor = .clearColor()
        
        textLabel.layer.borderWidth = 1
        textLabel.layer.borderColor = UIColor.ngOrangeColor().CGColor
        textLabel.layer.cornerRadius = CGRectGetMidY(textLabel.frame)
        textLabel.textColor = .ngOrangeColor()
        textLabel.textAlignment = .Center
        addSubview(textLabel)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(textLabel) { label in
            label.center == label.superview!.center
            label.width == CGRectGetWidth(self.textLabel.frame)
            label.height == CGRectGetHeight(self.textLabel.frame)
        }
    }
}
