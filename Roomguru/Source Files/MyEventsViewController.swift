//
//  MyEventsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import AKPickerView_Swift

class MyEventsViewController: EventsViewController {
    private weak var aView: DashboardView?
    private let alertViewTransitioningDelegate = AlertViewTransitionDelegate()
    
    required init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("My Events", comment: "")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("didTapPlusButton:"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Book First", comment: ""), style: .Plain, target: self, action: Selector("didTapBookRoomButton:"))
    }
    
    override func eventsListCoordinatorForDate(date: NSDate) -> EventsListCoordinator {
        
        let calendarIDs = CalendarPersistenceStore.sharedStore.rooms().map{ $0.id }
        return MyEventsListCoordinator(date: date, calendarIDs: calendarIDs)
    }
    
    override func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return 1
    }
    
    override func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return NSLocalizedString("All rooms", comment: "")
    }
}

// MARK: Actions

extension MyEventsViewController {
    
    func didTapBookRoomButton(sender: UIButton) {
        
        let barButtonItem = navigationItem.leftBarButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem.loaderItemWithTintColor(.ngOrangeColor())
        
        BookingManager.firstBookableCalendarEntry { (entry, error) in
            
            
            self.navigationItem.leftBarButtonItem = barButtonItem
            
            if let error = error {
                UIAlertView(error: error).show()
                
            } else if let entry = entry {
                self.presentBookingConfirmationViewControllerWithCalendarEntry(entry)
                
            } else {
                let message = NSLocalizedString("No available room found", comment: "")
                UIAlertView(message: message).show()
            }
        }
    }
    
    func didTapPlusButton(sender: UIBarButtonItem) {
        let editEventViewController = EditEventViewController() { event in
            self.reloadEventList()
        }
        let navigationController = NavigationController(rootViewController: editEventViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
}

private extension MyEventsViewController {
    
    func presentBookingConfirmationViewControllerWithCalendarEntry(entry: CalendarEntry) {
        
        let bookingConfirmationViewController = BookingConfirmationViewController(bookableEntry: entry) { bookedEntry in
            self.bookCalendarEntry(entry)
        }
        
        let navigationVC = NavigationController(rootViewController: bookingConfirmationViewController)
        let maskingVC = MaskingViewController(contentViewController: navigationVC)
        maskingVC.transitioningDelegate = alertViewTransitioningDelegate
        maskingVC.modalPresentationStyle = .Custom
        presentViewController(maskingVC, animated: true) {
            self.alertViewTransitioningDelegate.bindViewController(maskingVC, withView: maskingVC.aView.contentView)
        }
    }
    
    func bookCalendarEntry(entry: CalendarEntry) {
        
        BookingManager.bookCalendarEntry(entry) { (event, error) in
            
            if let error = error {
                UIAlertView(error: error).show()
            } else {
                let roomName = CalendarPersistenceStore.sharedStore.nameMatchingID(entry.calendarID)
                UIAlertView.alertViewForBookedEvent(entry.event, inRoomNamed: roomName).show()
                
                self.reloadEventList()
            }
        }
    }
}
