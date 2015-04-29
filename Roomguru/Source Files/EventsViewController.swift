//
//  EventsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 28/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {
    
    weak var aView: EventsView?
    
    override func loadView() {
        edgesForExtendedLayout = .None
        aView = loadViewWithClass(EventsView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let weekCarouselView = WeekCarouselView(frame: self.navigationController!.titleViewFrame())
        navigationItem.titleView = weekCarouselView
        
        let roomPickerViewController = addContainerViewController(RoomPickerViewController.self)
        aView?.roomPickerView = roomPickerViewController.view
        
        let pageViewController = addContainerViewController(EventsPageViewController.self)
        aView?.eventsPageView = pageViewController.view
    }
    
    deinit {
        removeContainerController(RoomPickerViewController.self)
        removeContainerController(EventsPageViewController.self)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        // NGRTemp: buggy
        coordinator.animateAlongsideTransition({ context in
            
            if let weekCarouselView = self.navigationItem.titleView as? WeekCarouselView {
                weekCarouselView.frame = self.navigationController!.titleViewFrame()
                weekCarouselView.collectionView?.collectionViewLayout.invalidateLayout()
            }
            
            self.navigationController?.navigationBar.frame = self.navigationController!.titleViewFrame()
            
            }, completion: { context in })
    }
}
