//
//  EventsPageViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EventsPageViewController: UIPageViewController {
    
    let eventsPageControllerDataSource = EventsPageViewControllerDataSource()
    let eventsPageControllerDelegate = EventsPageViewControllerDelegate()
    
    init() {
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = eventsPageControllerDelegate
        dataSource = eventsPageControllerDataSource
        setViewControllers([EventsListViewController(date: NSDate())], direction: .Forward, animated: true, completion: nil)
    }
}
