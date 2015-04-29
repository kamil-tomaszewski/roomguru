//
//  RoomPickerViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class RoomPickerViewController: UIViewController {
    
    weak var aView: RoomPickerView?
    
    // MARK: Lifecycle
    
    override func loadView() {
        aView = loadViewWithClass(RoomPickerView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aView?.collectionView?.delegate = self
        aView?.collectionView?.dataSource = self
        aView?.collectionView?.registerClass(RoomPickerCell.self, type: .Cell)
    }
}

// MARK: UICollectionViewFlowLayout

extension RoomPickerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfDaysInWeek: CGFloat = 7
        return CGSizeMake(CGRectGetWidth(collectionView.bounds) / numberOfDaysInWeek, CGRectGetHeight(collectionView.bounds))
    }
}

// MARK: UICollectionViewDataSource

extension RoomPickerViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableClass(RoomPickerCell.self, forIndexPath: indexPath, type: .Cell)
        
        cell.textLabel.text = String(indexPath.row)
        
        return cell
    }
}

//MARK: UICollectionViewDelegate

extension RoomPickerViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
