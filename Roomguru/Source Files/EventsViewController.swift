//
//  EventsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 28/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import AKPickerView_Swift

enum Designation {
    case Revocable, Browsable
}


// NGRTodo: Implementation of Revocable EventsViewController behaviour is needed

class EventsViewController: UIViewController {
    
    private weak var aView: EventsView?
    private var designation = Designation.Browsable
    private var selectedCalendarID: String!
    
    init(designation: Designation) {
        super.init(nibName: nil, bundle: nil)
        self.designation = designation
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        edgesForExtendedLayout = .None
        aView = loadViewWithClass(EventsView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarID = CalendarPersistenceStore.sharedStore.rooms().map{ $0.id }.first
        if calendarID == nil {
            // NGRTodo:
            fatalError("Display placeholder here")
            return
        }
        
        selectedCalendarID = calendarID!
        
        
        
        recreatePickerView()

        let weekCarouselViewController = addContainerViewController(WeekCarouselViewController.self)
        weekCarouselViewController.delegate = self
        aView?.weekCarouselView = weekCarouselViewController.view
        
        let pageViewController = addContainerViewController(EventsPageViewController.self)
        pageViewController.eventsDelegate = self
        pageViewController.showEventListWithDate(NSDate(), animated: false)
        aView?.eventsPageView = pageViewController.view
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("recreatePickerView"), name: CalendarPersistentStoreDidChangePersistentCalendars, object: nil)
    }
    
    deinit {
        removeContainerController(WeekCarouselViewController.self)
        removeContainerController(EventsPageViewController.self)
        
        NSNotificationCenter.defaultCenter().removeObserver(navigationItem.titleView!)
    }
    
    func recreatePickerView() {
        
        if designation == .Revocable {
            return
        }
        
        /* NOTE: Calling explicitly pickerView.reloadData() doesn't reload it's content. So when amount of calendars decreases.
                 numberOfItemsInPickerView() delegate doesn't fire and pickerView has wrong number of items what leads crash.
        */
        let pickerView = RoomHorizontalPicker(frame: navigationController!.titleViewFrame())
        pickerView.delegate = self
        pickerView.dataSource = self
        navigationItem.titleView = pickerView
    }
}

extension EventsViewController: WeekCarouselViewControllerDelegate {
    
    func weekCarouselViewController(controller: WeekCarouselViewController, didSelectDate date: NSDate) {
        if let eventsPageViewController = containerControllersOfType(EventsPageViewController.self).first {
            eventsPageViewController.showEventListWithDate(date, animated: true)
        }
    }
}

extension EventsViewController: EventsPageViewControllerDelegate {
    
    func eventsPageViewController(controller: EventsPageViewController, didScrollToDate date: NSDate) {
        if let weekCarouselController = containerControllersOfType(WeekCarouselViewController.self).first {
            weekCarouselController.scrollToSelectedDate(date, animated: true)
        }
    }
    
    func calendarIdentifiersToShowByEventsPageViewController(controller: EventsPageViewController) -> [String] {
        switch designation {
        case .Browsable:
            return [selectedCalendarID]
        case .Revocable:
            return CalendarPersistenceStore.sharedStore.rooms().map{ $0.id }
        }
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
        
        selectedCalendarID = CalendarPersistenceStore.sharedStore.rooms()[item].id
        
        if let eventsPageViewController = containerControllersOfType(EventsPageViewController.self).first {
            let date = eventsPageViewController.currentlyDisplayingDay
            eventsPageViewController.showEventListWithDate(date, animated: false)
        }
    }
}
