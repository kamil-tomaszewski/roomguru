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
    func eventsListCoordinatorForDate(date: NSDate) -> EventsListCoordinator
}

class EventsPageViewController: UIPageViewController {
    
    var currentlyDisplayingDay: NSDate { return (viewControllers.first as? EventsListViewController)?.coordinator.date ?? NSDate() }
    
    private var eventsDelegate: EventsPageViewControllerDelegate!

    required init(delegate: EventsPageViewControllerDelegate) {
        self.eventsDelegate = delegate
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
        setViewControllers([
            EventsListViewController(coordinator: eventsDelegate.eventsListCoordinatorForDate(date))
        ], direction: direction, animated: animated, completion: nil)
    }
}

extension EventsPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
        if !completed {
            return
        }
        
        if let eventsViewController = pageViewController.viewControllers.first as? EventsListViewController {
            eventsDelegate?.eventsPageViewController(self, didScrollToDate: eventsViewController.coordinator.date)
        }
    }
}

extension EventsPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let eventsViewController = viewController as? EventsListViewController {
            var date = eventsViewController.coordinator.date--
            return EventsListViewController(coordinator: eventsDelegate.eventsListCoordinatorForDate(date))
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let eventsViewController = viewController as? EventsListViewController {
            var date = eventsViewController.coordinator.date++
            return EventsListViewController(coordinator: eventsDelegate.eventsListCoordinatorForDate(date))
        }
        return nil
    }
}

private extension EventsPageViewController {
    
    func scollDirectionBasedOnDate(date: NSDate) -> UIPageViewControllerNavigationDirection {
        
        if let eventsViewController = viewControllers.first as? EventsListViewController {
            return eventsViewController.coordinator.date < date ? .Forward : .Reverse
        }
        return .Forward
    }
}
