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
        collectionView!.backgroundColor = .ngGrayColor()
        collectionView!.showsHorizontalScrollIndicator = false
        addSubview(collectionView!)
        
        addSubview(weekdaysBar)

        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(collectionView!, weekdaysBar) { collection, bar in
            
            bar.left == bar.superview!.left
            bar.top == bar.superview!.top
            bar.width == bar.superview!.width
            bar.height == 20
            
            collection.left == collection.superview!.left
            collection.top == bar.bottom
            collection.width == collection.superview!.width
            collection.bottom == collection.superview!.bottom
        }
    }
}
