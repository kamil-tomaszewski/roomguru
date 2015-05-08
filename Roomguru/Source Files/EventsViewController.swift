//
//  EventsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 28/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import AKPickerView_Swift

enum DisplayMode {
    case Revocable, Browsable
}

// NGRTodo: Implementation of Revocable EventsViewController behaviour is needed

class EventsViewController: UIViewController {
    
    private weak var aView: EventsView?
    private var mode = DisplayMode.Browsable
    private var selectedCalendarID: String?
    
    init(mode: DisplayMode) {
        super.init(nibName: nil, bundle: nil)
        self.mode = mode
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
        
        if let calendarID = (CalendarPersistenceStore.sharedStore.rooms().map{ $0.id }.first) {
            selectedCalendarID = calendarID
        }
        
        let weekCarouselViewController = WeekCarouselViewController()
        addContainerViewController(weekCarouselViewController)
        weekCarouselViewController.delegate = self
        aView?.weekCarouselView = weekCarouselViewController.view
        
        let pageViewController = EventsPageViewController(delegate: self)
        addContainerViewController(pageViewController)
        pageViewController.showEventListWithDate(NSDate(), animated: false)
        aView?.eventsPageView = pageViewController.view
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userDidChangePersistentCalendars"), name: CalendarPersistentStoreDidChangePersistentCalendars, object: nil)
    
        if CalendarPersistenceStore.sharedStore.rooms().isEmpty {
            aView?.showPlaceholderView(true)
        } else {
            recreatePickerView()
        }
    }
    
    deinit {
        removeContainerController(WeekCarouselViewController.self)
        removeContainerController(EventsPageViewController.self)
        
        if let pickerView = navigationItem.titleView {
            NSNotificationCenter.defaultCenter().removeObserver(pickerView)
        }
    }
    
    func userDidChangePersistentCalendars() {
        
        if let calendarID = (CalendarPersistenceStore.sharedStore.rooms().map{ $0.id }.first) {
            aView?.showPlaceholderView(false)
            selectedCalendarID = calendarID
        } else {
            aView?.showPlaceholderView(true)
            selectedCalendarID = nil
        }
        
        recreatePickerView()
        reloadEventList()
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
    
    func calendarIdentifiersToShowByEventsPageViewController(controller: EventsPageViewController) -> [String]? {
        switch mode {
        case .Browsable:
            if let selectedCalendarID = selectedCalendarID {
                return [selectedCalendarID]
            }
            return nil
        case .Revocable:
            return CalendarPersistenceStore.sharedStore.rooms().map{ $0.id }
        }
    }
    
    func shouldEventsPageViewControllerAllowToRevokeEvents(controller: EventsPageViewController) -> Bool {
        return mode == .Revocable
    }
}

extension EventsViewController: AKPickerViewDataSource {
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        if mode == .Revocable {
            return 1
        } else {
            return CalendarPersistenceStore.sharedStore.calendars.count
        }
    }

    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        
        if mode == .Revocable {
            return NSLocalizedString("All rooms", comment: "")
        } else {
            return CalendarPersistenceStore.sharedStore.rooms()[item].name
        }
    }
}

extension EventsViewController: AKPickerViewDelegate {
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        selectedCalendarID = CalendarPersistenceStore.sharedStore.rooms()[item].id
        reloadEventList()
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
        navigationItem.titleView = pickerView
    }
    
    func reloadEventList() {
        if let eventsPageViewController = containerControllersOfType(EventsPageViewController.self).first {
            let date = eventsPageViewController.currentlyDisplayingDay
            eventsPageViewController.showEventListWithDate(date, animated: false)
        }
    }
}
