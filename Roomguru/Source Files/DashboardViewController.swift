//
//  DashboardViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    private weak var aView: DashboardView?
    
    let revokeEventsPageControllerDataSource = RevokeEventsPageViewControllerDataSource()
//    var revokeEventsPageControllerDelegate = EventsPageViewControllerDelegate()
    
    private let viewModel = DashboardViewModel(items: [
        CellItem(title: "Revoke event", action: .Revoke),
        CellItem(title: "Book first available room", action: .Book),
    ])
    
    // MARK: View life cycle

    override func loadView() {
        aView = loadViewWithClass(DashboardView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("didTapPlusButton:"))
        
        setupTableView()
        centralizeTableView()
    }
}

// MARK: Actions

extension DashboardViewController {
 
    func didTapBookRoom(sender: UIButton) {
        
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
    
    func didTapRevokeBookedRoom(sender: UIButton) {
       
        let today = NSDate()
        let titleView = eventsTitleView(today)
//        
//        revokeEventsPageControllerDelegate = EventsPageViewControllerDelegate() { date in
//            titleView.detailTextLabel.text = date.string()
//        }
        
//        let revokeEventsPageController = revokeEventsPageViewController(today, dataSource: revokeEventsPageControllerDataSource, delegate: revokeEventsPageControllerDelegate)
        
//        revokeEventsPageController.navigationItem.titleView = titleView
//        revokeEventsPageController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel , target: revokeEventsPageController, action: Selector("dismissSelf:"))
//        
//        let navigationController = NavigationController(rootViewController: revokeEventsPageController)
        
//        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func didTapPlusButton(sender: UIBarButtonItem) {
        let viewModel = EditEventViewModel()
        let controller = EditEventViewController(viewModel: viewModel)
        let navigationController = NavigationController(rootViewController: controller)
        presentViewController(navigationController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource Methods

extension DashboardViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(ButtonCell.self)
            
        let item = viewModel[indexPath.row]
        var action: Selector;
        
        switch item.action {
        case .Book: action = Selector("didTapBookRoom:")
        case .Revoke: action = Selector("didTapRevokeBookedRoom:")
        }

        cell.button.setTitle(item.title)
        cell.button.backgroundColor = item.color
        cell.button.addTarget(self, action: action)
        
        return cell;
    }
}


// MARK: UITableViewDelegate Methods

extension DashboardViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

// MARK: Private Methods

private extension DashboardViewController {
    
    func setupTableView() {
        let tableView = aView?.tableView
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.registerClass(ButtonCell.self)
    }
    
    func centralizeTableView() {
        let topInset = max(0, (contentViewHeight() - requiredHeight()) / 2)
        aView?.tableView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    }
    
    func requiredHeight() -> CGFloat {
        
        if let rowHeight = aView?.tableView.rowHeight {
            return CGFloat(viewModel.numberOfItems()) * rowHeight
        }
        return 0
    }
    
    func contentViewHeight() -> CGFloat {
        
        let topInset = (self.navigationController != nil) ? self.navigationController!.navigationBar.frame.size.height : 0
        let bottomInset = (self.tabBarController != nil) ? self.tabBarController!.tabBar.frame.size.height : 0
        
        return (aView != nil) ? aView!.bounds.height - topInset - bottomInset : 0
    }
    
    func bookingConfirmationViewControllerWithCalendarTime(calendarTime: CalendarTimeFrame) -> BookingConfirmationViewController {
        
        return BookingConfirmationViewController(calendarTime, onConfirmation: { (actualCalendarTime, summary) -> Void in
            
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
    }
    
    // NGRTodo: This method will be removed soon.
    func eventsTitleView(date: NSDate) -> BasicTitleView {
        let titleView = BasicTitleView(frame: CGRectMake(0, 0, 200, 44))
        titleView.textLabel.text = NSLocalizedString("Revoke event", comment: "")
        titleView.detailTextLabel.text = date.string()
        return titleView
    }
    
    // NGRTodo: This method will be removed soon.
    func revokeEventsPageViewController(date: NSDate, dataSource: UIPageViewControllerDataSource, delegate: UIPageViewControllerDelegate) -> UIPageViewController {
        let pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageController.dataSource = dataSource
        pageController.delegate = delegate
//        pageController.setViewControllers([RevokeEventsListViewController(date: date)], direction: .Forward, animated: true, completion: nil)
        return pageController
    }
}

