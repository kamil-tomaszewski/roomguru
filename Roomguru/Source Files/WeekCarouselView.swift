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
        
        backgroundColor = .clearColor()
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: WeekCarouselFlowLayout())
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = .whiteColor()
        addSubview(collectionView!)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(collectionView!) { collection in            
            collection.edges == collection.superview!.edges; return
        }
    }
}
