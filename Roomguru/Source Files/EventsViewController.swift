//
//  EventsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 28/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import AKPickerView_Swift

class EventsViewController: UIViewController, EventsPageViewControllerDelegate {
    
    private weak var aView: EventsView?
    private var selectedCalendarID: String?
    
    required init() {
        super.init(nibName: nil, bundle: nil)
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
        
        updateSelectedCalendar()
        
        let weekCarouselViewController = WeekCarouselViewController()
        addContainerViewController(weekCarouselViewController)
        weekCarouselViewController.delegate = self
        aView?.weekCarouselView = weekCarouselViewController.view
        
        let pageViewController = EventsPageViewController(delegate: self)
        addContainerViewController(pageViewController)
        pageViewController.showEventListWithDate(NSDate(), animated: false)
        aView?.eventsPageView = pageViewController.view
        
        registerNotifications()
        updateControllerState()
    }
    
    deinit {
        removeContainerController(WeekCarouselViewController.self)
        removeContainerController(EventsPageViewController.self)
        
        registerNotifications(false)
    }
    
    func userDidChangePersistentCalendars() {
        
        updateSelectedCalendar()
        recreatePickerView()
        reloadEventList()
    }
    
    func reloadEventList() {
        if let eventsPageViewController = containerControllersOfType(EventsPageViewController.self).first {
            let date = eventsPageViewController.currentlyDisplayingDay
            eventsPageViewController.showEventListWithDate(date, animated: false)
        }
    }
    
    func updateSelectedCalendar() {
        if let calendarID = (CalendarPersistenceStore.sharedStore.rooms().map{ $0.id }.first) {
            selectedCalendarID = calendarID
        } else {
            selectedCalendarID = nil
        }
    }
    
    func updateControllerState() {
        
        if CalendarPersistenceStore.sharedStore.rooms().isEmpty {
            aView?.showPlaceholderView(true)
        } else {
            aView?.showPlaceholderView(false)
            recreatePickerView()
        }
    }
    
    // MARK: EventsPageViewControllerDelegate //declaration from extension cannot be override yet.
    
    func eventsPageViewController(controller: EventsPageViewController, didScrollToDate date: NSDate) {
        if let weekCarouselController = containerControllersOfType(WeekCarouselViewController.self).first {
            weekCarouselController.scrollToSelectedDate(date, animated: true)
        }
    }
    
    func eventsListCoordinatorForDate(date: NSDate) -> EventsListCoordinator {
        let calendarIDs = (selectedCalendarID != nil) ? [selectedCalendarID!] : []
        return EventsListCoordinator(date: date, calendarIDs: calendarIDs)
    }
}

extension EventsViewController: WeekCarouselViewControllerDelegate {
    
    func weekCarouselViewController(controller: WeekCarouselViewController, didSelectDate date: NSDate) {
        if let eventsPageViewController = containerControllersOfType(EventsPageViewController.self).first {
            eventsPageViewController.showEventListWithDate(date, animated: true)
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
        
        let rooms = CalendarPersistenceStore.sharedStore.rooms()
        if rooms.count > 0 {
            selectedCalendarID = rooms[item].id
            reloadEventList()
        }
    }
}

private extension EventsViewController {
    
    func recreatePickerView() {
        
        /* NOTE: Calling explicitly pickerView.reloadData() doesn't reload it's content. So when amount of calendars decreases.
        numberOfItemsInPickerView() delegate doesn't fire and pickerView has wrong number of items what leads crash.
        */
        let pickerView = RoomHorizontalPicker(frame: navigationController!.titleViewFrame())
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if numberOfItemsInPickerView(pickerView) > 0 {
            pickerView.selectItem(0, animated: false)
        }
        
        navigationItem.titleView = pickerView
    }
    
    func registerNotifications(_ register: Bool = true) {
        
        if register {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userDidChangePersistentCalendars"), name: CalendarPersistentStoreDidChangePersistentCalendars, object: nil)
        } else {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
}
