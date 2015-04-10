//
//  EventsPageViewControllerSource.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 10/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit
import DateKit


class EventsPageViewControllerSource: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var currentDate: NSDate = NSDate()
    
    // MARK: Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return EventsViewController(date: currentDate.days - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return EventsViewController(date: currentDate.days + 1)
    }
    
    
    // MARK: Delegate
    
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if let viewController = previousViewControllers.first as? EventsViewController {
            currentDate = viewController.timeMin
        }
    }
}

