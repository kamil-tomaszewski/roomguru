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

// MARK: UICollectionViewFlowLayout

extension WeekCarouselView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfDaysInWeek: CGFloat = 7
        return CGSizeMake(CGRectGetWidth(collectionView.bounds) / numberOfDaysInWeek, CGRectGetHeight(collectionView.bounds))
    }
}

// MARK: UICollectionViewDataSource

extension WeekCarouselView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        println(collectionView.bounds)
        return 14
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableClass(DayCarouselCell.self, forIndexPath: indexPath, type: .Cell)
        
        cell.textLabel.text = String(indexPath.row)
        
        return cell
    }
}

//MARK: UICollectionViewDelegate

extension WeekCarouselView: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

private extension WeekCarouselView {
    
    func commonInit() {
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: WeekCarouselFlowLayout())
        collectionView!.alwaysBounceHorizontal = true
        collectionView?.pagingEnabled = true
        collectionView!.backgroundColor = .ngGrayColor()
        addSubview(collectionView!)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.registerClass(DayCarouselCell.self, type: .Cell)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(collectionView!) { collection in
            collection.edges == collection.superview!.edges; return
        }
    }
}
