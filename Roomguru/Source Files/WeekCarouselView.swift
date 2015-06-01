//
//  WeekCarouselView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 28/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class WeekCarouselView: UIView {
    
    let todayButton = UIButton.buttonWithType(.System) as! UIButton
    let textLabel = UILabel()
    
    private(set) var collectionView: UICollectionView?
    
    private let weekdaysBar = WeekdaysBar()
    private let bottomLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func setDayNamesWithDateFormatter(formatter: NSDateFormatter) {
        
        for (index, element) in enumerate(weekdaysBar.daysLabels) {
            
            let i = (index + formatter.calendar.firstWeekday - 1) % formatter.shortWeekdaySymbols.count
            element.text = formatter.shortWeekdaySymbols[i] as? String
        }
    }
}

private extension WeekCarouselView {
    
    func commonInit() {
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: WeekCarouselFlowLayout())
        collectionView!.alwaysBounceHorizontal = true
        collectionView!.pagingEnabled = true
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.showsHorizontalScrollIndicator = false
        addSubview(collectionView!)
        
        addSubview(weekdaysBar)
        
        textLabel.textAlignment = .Center
        textLabel.textColor = UIColor.ngGrayColor()
        textLabel.font = .systemFontOfSize(15)
        addSubview(textLabel)
        
        bottomLine.backgroundColor = UIColor.rgb(200, 200, 200)
        addSubview(bottomLine)
        
        todayButton.setTitleColor(UIColor.ngOrangeColor(), forState: .Normal)
        todayButton.setTitle(NSLocalizedString("Today", comment: ""))
        addSubview(todayButton)

        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(bottomLine, weekdaysBar, textLabel) { line, bar, label in
            
            bar.left == bar.superview!.left
            bar.top == bar.superview!.top
            bar.width == bar.superview!.width
            bar.height == 20
            
            line.left == line.superview!.left
            line.bottom == line.superview!.bottom
            line.width == line.superview!.width
            line.height == 1
            
            label.left == label.superview!.left
            label.bottom == line.top
            label.width == label.superview!.width
            label.height == 26
        }
        
        layout(collectionView!, weekdaysBar, textLabel) { collection, bar, label in
            
            collection.left == collection.superview!.left
            collection.top == bar.bottom
            collection.width == collection.superview!.width
            collection.bottom == label.top
        }
        
        layout(todayButton, textLabel) { button, label in
         
            button.left == button.superview!.left
            button.bottom == button.superview!.bottom
            button.height == label.height
            button.width == 60
        }
    }
}
