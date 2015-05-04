//
//  EventsPageViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol EventsPageViewControllerDelegate {
    
    func eventsPageViewController(controller: EventsPageViewController, didScrollToDate date: NSDate)
    func calendarIdentifiersToShowByEventsPageViewController(controller: EventsPageViewController) -> [String]?
}

class EventsPageViewController: UIPageViewController {
    
    var eventsDelegate: EventsPageViewControllerDelegate?
    var currentlyDisplayingDay: NSDate { get { return (viewControllers.first as? EventsListViewController)?.date ?? NSDate() }}

    init() {
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
    }
    
    func showEventListWithDate(date: NSDate, animated: Bool) {
        let direction = scollDirectionBasedOnDate(date)
        setViewControllers([EventsListViewController(date: date, calendarIDs: calendarIDs())], direction: direction, animated: animated, completion: nil)
    }
}

extension EventsPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
        if !completed {
            return
        }
        
        if let eventsViewController = pageViewController.viewControllers.first as? EventsListViewController {
            eventsDelegate?.eventsPageViewController(self, didScrollToDate: eventsViewController.date)
        }
    }
}

extension EventsPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let eventsViewController = viewController as? EventsListViewController {
            var date = eventsViewController.date--
            return EventsListViewController(date: date, calendarIDs: calendarIDs())
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let eventsViewController = viewController as? EventsListViewController {
            var date = eventsViewController.date++
            return EventsListViewController(date: date, calendarIDs: calendarIDs())
        }
        return nil
    }
}

private extension EventsPageViewController {
    
    func calendarIDs() -> [String] {
        return eventsDelegate?.calendarIdentifiersToShowByEventsPageViewController(self) ?? []
    }
    
    func scollDirectionBasedOnDate(date: NSDate) -> UIPageViewControllerNavigationDirection {
        
        if let eventsViewController = viewControllers.first as? EventsListViewController {
            return eventsViewController.date.isEarlierThan(date) ? .Forward : .Reverse
        }
        return .Forward
    }
}
