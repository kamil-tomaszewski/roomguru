//
//  WeekCarouselViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import DateKit

class WeekCarouselViewController: UIViewController {
    
    weak var aView: WeekCarouselView?
    private let viewModel = WeekCarouselViewModel()
    private var selectedDate = NSDate()
    
    // MARK: Lifecycle
    
    override func loadView() {
        aView = loadViewWithClass(WeekCarouselView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aView?.collectionView?.delegate = self
        aView?.collectionView?.dataSource = self
        aView?.collectionView?.registerClass(DayCarouselCell.self, type: .Cell)
    }
}

// MARK: UICollectionViewFlowLayout

extension WeekCarouselViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfDaysInWeek: CGFloat = 7
        return CGSizeMake(CGRectGetWidth(collectionView.bounds) / numberOfDaysInWeek, CGRectGetHeight(collectionView.bounds))
    }
}

// MARK: UICollectionViewDataSource

extension WeekCarouselViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.days.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableClass(DayCarouselCell.self, forIndexPath: indexPath, type: .Cell)
        
        cell.textLabel.text = viewModel[indexPath.row].day
        
        var style = DayCellStyle.Normal
        if selectedDate.days == viewModel[indexPath.row].date.days {
            style = .Selected
        } else if viewModel[indexPath.row].isToday {
            style = .Today
        }
        
        cell.setAppearanceWithStyle(style)
        
        return cell
    }
}

//MARK: UICollectionViewDelegate

extension WeekCarouselViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedDate = viewModel[indexPath.row].date
        collectionView.reloadData()
        aView?.textLabel.text = viewModel.dateStringWithIndex(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
