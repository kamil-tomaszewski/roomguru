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
}

class EventsPageViewController: UIPageViewController {
    
    private var date = NSDate()
    
    var eventsDelegate: EventsPageViewControllerDelegate?

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
        setViewControllers([EventsListViewController(date: NSDate(), calendarID: calendarID())], direction: .Forward, animated: true, completion: nil)
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
            return EventsListViewController(date: date, calendarID: self.calendarID())
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let eventsViewController = viewController as? EventsListViewController {
            var date = eventsViewController.date++
            return EventsListViewController(date: date, calendarID: self.calendarID())
        }
        return nil
    }
}

private extension EventsPageViewController {
    
    func calendarID() -> String {
        // NGRTemp: mocked temporary, will use delegate for that:
        return CalendarPersistenceStore.sharedStore.rooms().map{ $0.id }.first!
    }
}
