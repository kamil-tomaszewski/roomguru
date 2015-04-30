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
    
    func scrollToDate(date: NSDate, animated: Bool) {
        
        if let index = viewModel.indexFromDate(date), collectionView = aView?.collectionView {

            let offset = floor(CGFloat(index/viewModel.numberOfDaysInWeek))
            let rect = CGRectMake(offset * CGRectGetWidth(collectionView.bounds), 0, CGRectGetWidth(collectionView.bounds), CGRectGetHeight(collectionView.bounds))
            collectionView.scrollRectToVisible(rect, animated: animated)
        }
    }
    
    func shiftWeekToDay(date: NSDate?, animated: Bool) {

        if let date = date {
            
            viewModel.populateDaysArrayWithCentralWeekRepresentedByDate(date)
            aView?.collectionView?.reloadData()
            scrollToDate(date, animated: false)
        }
    }
}

////----------------------------------------------------------------------------------------
//- (void)shiftMonthWithTransition:(PKCalendarMonthTransition)transition animation:(PKCalendarMonthAnimation)animation {
//    
//    PKCalendarCollectionView *collectionView = _calendarView.calendarCollectionView;
//    
//    NSArray *visibleItems = [collectionView indexPathsForVisibleItems];
//    if ([visibleItems count] < 1) {
//        [collectionView setContentOffset:CGPointZero];
//        return;
//    }
//    
//    NSDateComponents *components = [NSDateComponents new];
//    components.month = transition;
//    
//    //find lowest indexPath in collectionView
//    NSInteger rowMin = INT_MAX;
//    NSInteger fromSection = INT_MAX;
//    
//    //find lowest row:
//    for (NSIndexPath *indexPath in visibleItems) {
//        if (rowMin > indexPath.row) {
//            fromSection = indexPath.section;
//            rowMin = indexPath.row;
//        }
//    }
//    
//    //calculate bounds of change:
//    NSDate *fromSectionOfDate = [self dateOfFirstDayInSection:fromSection];
//    _startDate = [_calendar dateByAddingComponents:components toDate:_startDate options:0];
//    _endDate = [_calendar dateByAddingComponents:components toDate:_endDate options:0];
//    NSInteger toSection = [_calendar components:NSMonthCalendarUnit fromDate:_startDate toDate:fromSectionOfDate options:0].month;
//    
//    //if section is outside collectionView sectionBounds (2 * monthDeltaRangeInMemory), then recalculate start and end dates
//    if (toSection < 0 || toSection > 2.0f * monthDeltaRangeInMemory - 2) {
//        components.month = toSection;
//        _startDate = [_calendar dateByAddingComponents:components toDate:_startDate options:0];
//        _endDate = [_calendar dateByAddingComponents:components toDate:_endDate options:0];
//    }
//    
//    //reload & invalidate
//    [collectionView reloadData];
//    [collectionView.collectionViewLayout invalidateLayout];
//    [collectionView.collectionViewLayout prepareLayout];
//    
//    //calculate accurate section, then set offset without animation
//    NSInteger y = collectionView.contentOffset.y + (toSection - fromSection) * CGRectGetHeight(collectionView.frame);
//    y = toSection * CGRectGetHeight(collectionView.frame);
//    [collectionView setContentOffset:CGPointMake(collectionView.contentOffset.x, y)];
//    
//    //if animated then animate!
//    if (animation != PKCalendarMonthAnimationNoone) {
//        NSInteger section = y/CGRectGetHeight(collectionView.frame) + animation;
//        y = section * CGRectGetHeight(collectionView.frame);
//        [collectionView setContentOffset:CGPointMake(collectionView.contentOffset.x, y) animated:YES];
//    }
//}
