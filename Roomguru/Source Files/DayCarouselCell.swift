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
    
    let textLabel = UILabel()
    
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
        
        backgroundColor = UIColor.whiteColor()
        
        textLabel.backgroundColor = .redColor()
        addSubview(textLabel)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(textLabel) { label in
            
            label.edges == inset(label.superview!.edges, 10)
        }
    }
}

