//
//  SettingsView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    
    private(set) var collectionView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {                
        let layout = StickyExpandableFlowLayout()
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.whiteColor()
        addSubview(collectionView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /* NOTE: Cartography not use because of internal error:
        *** Assertion failure in 
        -[UICollectionView _createPreparedSupplementaryViewForElementOfKind:atIndexPath:withLayoutAttributes:applyAttributes:], /
        SourceCache/UIKit_Sim/UIKit-3347.44/UICollectionView.m:1400
        
        in ConstraintGroup performLayout()
        */
        
        collectionView?.frame = self.bounds
    }
}
