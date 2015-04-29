//
//  RoomPickerView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class RoomPickerView: UIView {
    
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

private extension RoomPickerView {
    
    func commonInit() {
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: WeekCarouselFlowLayout())
        collectionView!.alwaysBounceHorizontal = true
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
