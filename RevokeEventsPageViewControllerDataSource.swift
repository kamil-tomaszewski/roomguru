//
//  RevokeEventsPageViewControllerDataSource.swift
//  Roomguru
//
//  Created by Aleksander Popko on 27.04.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import DateKit

class RevokeEventsPageViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? RevokeEventsViewController {
            let date = viewController.timeMax.days + 1
            return RevokeEventsViewController(date: date)
        }
        return nil
    }
    
    func  pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? RevokeEventsViewController {
            let date : NSDate = viewController.timeMax.days - 1
            let today = NSDate()
            return date >= today ? RevokeEventsViewController(date: date) : nil
        }
        return nil
    }
   
}
