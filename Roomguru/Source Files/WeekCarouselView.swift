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
    
    private(set) var collectionView: UICollectionView?
    private let weekdaysBar = WeekdaysBar()
    let textLabel = UILabel()
    private let bottomLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension WeekCarouselView {
    
    func commonInit() {
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: WeekCarouselFlowLayout())
        collectionView!.alwaysBounceHorizontal = true
        collectionView!.pagingEnabled = true
        collectionView!.backgroundColor = .whiteColor()
        collectionView!.showsHorizontalScrollIndicator = false
        addSubview(collectionView!)
        
        addSubview(weekdaysBar)
        
        textLabel.textAlignment = .Center
        textLabel.text = "Temporary label"
        textLabel.textColor = .ngGrayColor()
        textLabel.font = .systemFontOfSize(14)
        addSubview(textLabel)
        
        bottomLine.backgroundColor = .rgb(200, 200, 200)
        addSubview(bottomLine)

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
    }
}
