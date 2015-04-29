//
//  WeekCarouselViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol WeekCarouselViewControllerDelegate {
    
    func weekCarouselViewController(controller: WeekCarouselViewController, didSelectDate date: NSDate)
}

class WeekCarouselViewController: UIViewController {
    
    weak var aView: WeekCarouselView?
    private let viewModel = WeekCarouselViewModel()
    private var selectedDate = NSDate()
    private var didShowViewController = false
    
    var delegate: WeekCarouselViewControllerDelegate?
    
    // MARK: Lifecycle
    
    override func loadView() {
        aView = loadViewWithClass(WeekCarouselView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aView?.collectionView?.delegate = self
        aView?.collectionView?.dataSource = self
        aView?.collectionView?.registerClass(DayCarouselCell.self, type: .Cell)
        
        if let index = viewModel.indexFromDate(selectedDate) {
            aView?.textLabel.text = viewModel.dateStringWithIndex(index)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didShowViewController {
            scrollToDate(selectedDate, animated: false)
            didShowViewController = true
        }
    }
}

// MARK: UICollectionViewFlowLayout

extension WeekCarouselViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds) / CGFloat(viewModel.numberOfDaysInWeek), CGRectGetHeight(collectionView.bounds))
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
        let date = viewModel[indexPath.row].date
        
        if date.isSameDayAs(selectedDate) {
            style = .Selected
        } else if date.isToday() {
            style = .Today
        } else if date.isEarlierThanToday() {
            style = .Past
        }
        
        cell.setAppearanceWithStyle(style)
        
        return cell
    }
}

//MARK: UICollectionViewDelegate

extension WeekCarouselViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
 
        if !viewModel[indexPath.row].date.isEqualToDate(selectedDate) {
            
            selectedDate = viewModel[indexPath.row].date
            collectionView.reloadData()
            aView?.textLabel.text = viewModel.dateStringWithIndex(indexPath.row)
            delegate?.weekCarouselViewController(self, didSelectDate: selectedDate)
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

private extension WeekCarouselViewController {
    
    func scrollToDate(date: NSDate, animated: Bool) {
        
        if let index = viewModel.indexFromDate(date), collectionView = aView?.collectionView {
            
            let offset = CGFloat(index % viewModel.numberOfDaysInWeek)
            let rect = CGRectMake(offset * CGRectGetWidth(collectionView.bounds), 0, CGRectGetWidth(collectionView.bounds), CGRectGetHeight(collectionView.bounds))
            collectionView.scrollRectToVisible(rect, animated: animated)
        }
    }
}
