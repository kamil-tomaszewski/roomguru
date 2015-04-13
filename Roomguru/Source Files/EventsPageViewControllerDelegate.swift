//
//  EventsPageViewControllerDelegate.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

class EventsPageViewControllerDelegate: NSObject {
    
    convenience init(onFinishedAnimation: DateBlock) {
        self.init()
        self.onFinishedAnimating = onFinishedAnimation
    }
    
    override init() {
        super.init()
    }
    
    private var onFinishedAnimating: DateBlock?
}

// MARK: UIPageViewControllerDelegate

extension EventsPageViewControllerDelegate: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if let eventsViewController = pageViewController.viewControllers.first as? EventsViewController {
            onFinishedAnimating?(date: eventsViewController.timeMax)
        }
    }
}
