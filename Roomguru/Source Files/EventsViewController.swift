//
//  EventsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 28/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import AKPickerView_Swift

class EventsViewController: UIViewController {
    
    private weak var aView: EventsView?
    
    override func loadView() {
        edgesForExtendedLayout = .None
        aView = loadViewWithClass(EventsView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = RoomHorizontalPicker(frame: navigationController!.titleViewFrame())
        pickerView.delegate = self
        pickerView.dataSource = self
        navigationItem.titleView = pickerView
        
        let weekCarouselViewController = addContainerViewController(WeekCarouselViewController.self)
        weekCarouselViewController.delegate = self
        aView?.weekCarouselView = weekCarouselViewController.view
        
        let pageViewController = addContainerViewController(EventsPageViewController.self)
        aView?.eventsPageView = pageViewController.view
    }
    
    deinit {
        removeContainerController(WeekCarouselViewController.self)
        removeContainerController(EventsPageViewController.self)
    }
}

extension EventsViewController: WeekCarouselViewControllerDelegate {
    
    func weekCarouselViewController(controller: WeekCarouselViewController, didSelectDate date: NSDate) {
        println(date)
    }
}

extension EventsViewController: AKPickerViewDataSource {
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return CalendarPersistenceStore.sharedStore.calendars.count
    }

    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return CalendarPersistenceStore.sharedStore.rooms()[item].name
    }
}

extension EventsViewController: AKPickerViewDelegate {
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        println("PickerView did select \(CalendarPersistenceStore.sharedStore.rooms()[item].name)")
    }
}
