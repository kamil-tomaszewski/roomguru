//
//  EventsViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PKHUD

class EventsListViewController: UIViewController {
    
    private weak var aView: EventsListView?
    private(set) var coordinator: EventsListCoordinator
    private let alertViewTransitionDelegate = AlertViewTransitionDelegate()

    convenience init(coordinator: EventsListCoordinator) {
        self.init()
        self.coordinator = coordinator
    }
    
    init() {
        self.coordinator = EventsListCoordinator(date: NSDate(), calendarIDs: [])
        super.init(nibName:nil,bundle:nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.coordinator = EventsListCoordinator(date: NSDate(), calendarIDs: [])
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        aView = loadViewWithClass(EventsListView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupTableView()
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isMovingToParentViewController() {
            self.aView?.tableView.deselectRowIfSelectedAnimated(true)
        }
    }
    
    func loadData(completion: VoidBlock? = nil) {
        
        aView?.showPlaceholder(false, withIcon: nil, text: "")
        coordinator.loadDataWithCompletion { [weak self] (status, message, icon) in
            
            self?.aView?.tableView.reloadData()
            
            switch status {
            case .Failed, .Empty:
                self?.aView?.showPlaceholder(true, withIcon: icon, text: message)
                self?.aView?.tableView.alpha = 1.0
            case .Success:
                self?.scrollToNowAnimated(false)
                fade(.In, self?.aView?.tableView, duration: 0.5) { }
            }
            
            completion?()
        }
    }
}

// MARK: UITableViewDelegate

extension EventsListViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let event = coordinator.viewModel?.eventAtIndex(indexPath)
        
        if let freeEvent = event as? FreeEvent {

            coordinator.viewModel?.selectOrDeselectFreeEventAtIndexPath(indexPath)
            var indexPaths = coordinator.viewModel?.indexPathsToReload() ?? []
            indexPaths.append(indexPath)
            aView?.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)

        } else {
            let controller = EventDetailsViewController(event: event) {
                self.loadData()
            }
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return coordinator.viewModel?.isSelectableIndex(indexPath) ?? true
    }
}

// MARK: UITableViewDataSource

extension EventsListViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return coordinator.viewModel?.sectionsCount() ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coordinator.viewModel?[section].count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let event = coordinator.viewModel?.eventAtIndex(indexPath)
        let cell = dequeueCellForEvent(event!, inTableView: tableView)
        
        let now = NSDate()
        
        if now > event!.end {
            cell.setStyle(.Past)
        } else if now.between(earlier: event!.start, later: event!.end) {
            cell.setStyle(.Current)
        } else {
            cell.setStyle(.Future)
        }
        
        configureCell(cell, forEvent: event!, indexPath: indexPath)
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (coordinator.viewModel?.eventAtIndex(indexPath) is FreeEvent) ? 44 : 60
    }
    
    func dequeueCellForEvent(event: Event, inTableView tableView: UITableView) -> EventCell {
        if let freeEvent = event as? FreeEvent {
            return tableView.dequeueReusableCell(FreeEventCell.self)
        } else {
            return tableView.dequeueReusableCell(EventCell.self)
        }
    }
}

// MARK: UIControl methods

extension EventsListViewController {
    
    // NGRTodo: attach book view controller:
    
    func didTapBookButton(sender: UIButton) {
        let timeRange = coordinator.viewModel?.selectedTimeRangeToBook()
        
        if let timeRange = timeRange, calendarID = coordinator.eventsProvider.calendarIDs.first {
            
            let timeFrame = TimeFrame(startDate: timeRange.min, endDate: timeRange.max, availability: .Available)
            let calendarTime = (timeFrame, calendarID)
            
//            let viewModel = BookingConfirmationViewModel(calendarTimeFrame: calendarTime, onConfirmation: { (actualCalendarTime, summary) -> Void in
//                
//                BookingManager.bookTimeFrame(actualCalendarTime, summary: summary, success: { (event: Event) in
//                    
//                    let roomName = CalendarPersistenceStore.sharedStore.nameMatchingID(actualCalendarTime.1)
//                    UIAlertView.alertViewForBookedEvent(event, inRoomNamed: roomName).show()
//                    
//                    self.loadData()
//                        
//                }, failure: { (error: NSError) in
//                    UIAlertView(error: error).show()
//                })
//            })
            
//            let controller = BookingConfirmationViewController(viewModel: viewModel)
//            let navigationVC = NavigationController(rootViewController: controller)
//            let maskingVC = MaskingViewController(contentViewController: navigationVC)
//            maskingVC.modalPresentationStyle = .Custom
//            maskingVC.transitioningDelegate = alertViewTransitionDelegate
//            
//            presentViewController(maskingVC, animated: true) {
//                self.alertViewTransitionDelegate.bindViewController(maskingVC, withView: maskingVC.aView.contentView)
//            }
        }
    }
    
    func didPullRefreshControl(refreshControl: UIRefreshControl) {
        loadData() {
            refreshControl.endRefreshing()
        }
    }
}

private extension EventsListViewController {
    
    // MARK: Cell configuration
    
    func configureCell(cell: EventCell, forEvent event: Event, indexPath: NSIndexPath) {
        
        if cell.isKindOfClass(FreeEventCell.self)  {
            configureFreeEventCell(cell as! FreeEventCell, forEvent: event as! FreeEvent, indexPath: indexPath)
            
        } else if cell.isKindOfClass(EventCell.self)  {
            configureEventCell(cell, forEvent: event)
        }
    }
    
    func configureFreeEventCell(cell: FreeEventCell, forEvent event: FreeEvent, indexPath: NSIndexPath) {
        let minutes = event.duration/60
        
        cell.timeLabel.text = "Book \(Int(minutes)) min"
        cell.timeMinLabel.text = event.startTime
        cell.timeMaxLabel.text = event.endTime
        cell.bookButton.addTarget(self, action: Selector("didTapBookButton:"))
        
        if let tuple = coordinator.viewModel?.isFreeEventSelectedAtIndex(indexPath) {
            cell.contentView.backgroundColor = tuple.selected ? .ngGreenColor() : .ngOrangeColor()
            cell.bookButton.hidden = !tuple.lastUserSelection
        }
    }
    
    func configureEventCell(cell: EventCell, forEvent event: Event) {
        
        let calendar = CalendarPersistenceStore.sharedStore.calendars.filter { $0.identifier == event.rooms.first!.email }.first
        if let calendar = calendar, colorHex = calendar.colorHex {
            cell.colorView.backgroundColor = UIColor.hex(colorHex)
        }
        
        cell.textLabel?.text = event.summary
        cell.timeMinLabel.text = event.startTime
        cell.timeMaxLabel.text = event.endTime
    }
    
    // MARK:

    func setupTableView() {

        aView?.tableView.dataSource = self
        aView?.tableView.delegate = self
        aView?.tableView.backgroundColor = UIColor.clearColor()

        aView?.tableView.registerClass(EventCell.self)
        aView?.tableView.registerClass(FreeEventCell.self)

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("didPullRefreshControl:"), forControlEvents: .ValueChanged)
        aView?.tableView.addSubview(refreshControl)
    }
    
    func scrollToNowAnimated(animated: Bool) {
        
        let now = NSDate()
        
        if !coordinator.date.isSameDayAs(now) {
            return
        }
        
        if let path = coordinator.viewModel?.indexOfItemWithDate(now) {
            let indexPath = NSIndexPath(forRow: path.row, inSection: path.section)
            aView?.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: animated)
        }
    }
}
