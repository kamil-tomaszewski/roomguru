//
//  DashboardViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

// NGRTodo: should be replaced by MyEventsViewController

class DashboardViewController: UIViewController {

    private weak var aView: DashboardView?
    
    // MARK: View life cycle

    override func loadView() {
        aView = loadViewWithClass(DashboardView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("didTapPlusButton:"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Book First", comment: ""), style: .Plain, target: self, action: Selector("didTapBookRoomButton:"))
    }
}

// MARK: Actions

extension DashboardViewController {
 
    func didTapBookRoomButton(sender: UIButton) {
        
        // NGRTodo: this shouldn't be done here. User shouldn't wait for server response.
        
        BookingManager.findClosestAvailableRoom { (calendarTime, error) in
            if let _error = error {
                UIAlertView(error: _error).show()
                
            } else if let _calendarTime = calendarTime {
                
                let confirmationViewController = self.bookingConfirmationViewControllerWithCalendarTime(_calendarTime)
                let navigationVC = NavigationController(rootViewController: confirmationViewController)
                self.presentViewController(navigationVC, animated: true, completion: nil)
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

private extension DashboardViewController {
    
    func bookingConfirmationViewControllerWithCalendarTime(calendarTime: CalendarTimeFrame) -> BookingConfirmationViewController {
        
        let viewModel = BookingConfirmationViewModel(calendarTimeFrame: calendarTime, onConfirmation: { (actualCalendarTime, summary) -> Void in
            
            BookingManager.bookTimeFrame(actualCalendarTime, summary: summary, success: { (event: Event) in
                
                if let startTimeString = event.startTime, let endTimeString = event.endTime {
                    let message = NSLocalizedString("Booked room", comment: "") + " from " + startTimeString + " to " + endTimeString
                    UIAlertView(title: NSLocalizedString("Success", comment: ""), message: message).show()
                    self.aView?.tableView.reloadData()
                }
                
                }, failure: { (error: NSError) in
                    UIAlertView(error: error).show()
                }
            )
        })
        
        return BookingConfirmationViewController(viewModel: viewModel)
    }
}

