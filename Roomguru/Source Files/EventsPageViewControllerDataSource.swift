//
//  EventsPageViewControllerDataSource.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 10/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import DateKit


class EventsPageViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? EventsListViewController {
            let date = viewController.timeMax.days - 1
            return EventsListViewController(date: date)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? EventsListViewController {
            let date = viewController.timeMax.days + 1
            return EventsListViewController(date: date)
        }
        
        return nil
    }
}
