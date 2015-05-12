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
    private let alertViewTransitioninigDelegate = AlertViewTransitionDelegate()

    required init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotifications(false)
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

        // NGRTodo: this shouldn't be done here. User shouldn't wait for server response.

        BookingManager.findClosestAvailableRoom { (calendarTime, error) in
            if let error = error {
                UIAlertView(error: error).show()

            } else if let calendarTime = calendarTime {

                let confirmationViewController = self.bookingConfirmationViewControllerWithCalendarTime(calendarTime)
                let navigationVC = NavigationController(rootViewController: confirmationViewController)

                let maskingVC = MaskingViewController(contentViewController: navigationVC)
                maskingVC.transitioningDelegate = self.alertViewTransitioninigDelegate
                maskingVC.modalPresentationStyle = .Custom
                self.presentViewController(maskingVC, animated: true) {
                    self.alertViewTransitioninigDelegate.bindViewController(maskingVC, withView: maskingVC.aView.contentView)
                }
            }
        }
    }

    func didTapPlusButton(sender: UIBarButtonItem) {
        let viewModel = EditEventViewModel()
        let controller = EditEventViewController(viewModel: viewModel)
        let navigationController = NavigationController(rootViewController: controller)
        presentViewController(navigationController, animated: true, completion: nil)
    }
}

// MARK: Private Methods

private extension MyEventsViewController {

    func bookingConfirmationViewControllerWithCalendarTime(calendarTime: CalendarTimeFrame) -> BookingConfirmationViewController {

        let viewModel = BookingConfirmationViewModel(calendarTimeFrame: calendarTime, onConfirmation: { (actualCalendarTime, summary) -> Void in

            BookingManager.bookTimeFrame(actualCalendarTime, summary: summary, success: { (event: Event) in

                let message = NSLocalizedString("Booked room", comment: "") + " from " + event.startTime + " to " + event.endTime
                UIAlertView(title: NSLocalizedString("Success", comment: ""), message: message).show()

                self.reloadEventList()

            }, failure: { (error: NSError) in
                UIAlertView(error: error).show()
            })
        })

        return BookingConfirmationViewController(viewModel: viewModel)
    }
}
