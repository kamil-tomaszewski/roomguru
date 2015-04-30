//
//  WeekdaysBar.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class WeekdaysBar: UIView {
    
    private(set) var daysLabels: [UILabel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width: CGFloat = CGRectGetWidth(bounds) / 7
        
        for (index, element) in enumerate(daysLabels) {
            element.frame = CGRectMake(width * CGFloat(index), 0, width, CGRectGetHeight(frame))
        }
    }
}

private extension WeekdaysBar {
    
    func commonInit() {
        backgroundColor = UIColor.whiteColor()
        
        for i in 0..<7 {

            let label = UILabel()
            label.textAlignment = .Center
            label.textColor = .ngGrayColor()
            label.font = .systemFontOfSize(14)
            addSubview(label)
            daysLabels.append(label)
        }
    }
}
