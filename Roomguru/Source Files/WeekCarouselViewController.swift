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
    
    private weak var aView: WeekCarouselView?
    private let viewModel = WeekCarouselViewModel()
    private var selectedDate = NSDate() // to inform delegate about changes use setSelectedDate:informDelegate method
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
        aView?.todayButton.addTarget(self, action: Selector("didTapTodayButton:"))
        
        aView?.setDayNamesWithDateFormatter(viewModel.dateFormatter)
        aView?.textLabel.text = viewModel.dateStringFromDate(selectedDate)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didShowViewController {
            scrollToDate(selectedDate, animated: false)
            didShowViewController = true
        }
    }
    
    func didTapTodayButton(sender: UIButton) {
        setSelectedDate(NSDate(), informDelegate: true)
        scrollToDate(selectedDate, animated: false)
    }
    
    func scrollToSelectedDate(date: NSDate, animated: Bool) {
        setSelectedDate(date, informDelegate: false)
        scrollToDate(date, animated: animated)
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
        setSelectedDate(viewModel[indexPath.row].date, informDelegate: true)
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

//MARK: UIScrollViewDelegate

extension WeekCarouselViewController {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let x = scrollView.contentOffset.x
        let offset = ceil(x/CGRectGetWidth(scrollView.frame))

        if x < CGRectGetWidth(scrollView.bounds) {
            shiftWeekToDay(viewModel.days.first, animated: false)
        } else if x > (scrollView.contentSize.width - CGRectGetWidth(scrollView.bounds)) {
            shiftWeekToDay(viewModel.days.last, animated: false)
        }
    }
}

//MARK: Private

private extension WeekCarouselViewController {
    
    func shiftWeekToDay(date: NSDate?, animated: Bool) {

        if let date = date {
            
            viewModel.populateDaysArrayWithCentralWeekRepresentedByDate(date)
            aView?.collectionView?.reloadData()
            scrollToDate(date, animated: false)
        }
    }
    
    func setSelectedDate(date: NSDate, informDelegate: Bool) {
        if date.isSameDayAs(selectedDate) {
            return
        }
        
        selectedDate = date
        aView?.collectionView?.reloadData()
        aView?.textLabel.text = viewModel.dateStringFromDate(date)
        if informDelegate {
            delegate?.weekCarouselViewController(self, didSelectDate: selectedDate)
        }
    }
    
    func scrollToDate(date: NSDate, animated: Bool) {
        
        if !viewModel.containsDate(date) {
            viewModel.populateDaysArrayWithCentralWeekRepresentedByDate(date)
        }
        
        if let index = viewModel.indexFromDate(date), collectionView = aView?.collectionView {
            
            let offset = floor(CGFloat(index/viewModel.numberOfDaysInWeek))
            let rect = CGRectMake(offset * CGRectGetWidth(collectionView.bounds), 0, CGRectGetWidth(collectionView.bounds), CGRectGetHeight(collectionView.bounds))
            collectionView.scrollRectToVisible(rect, animated: animated)
        }
    }
}
