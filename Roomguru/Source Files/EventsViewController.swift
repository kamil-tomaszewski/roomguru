//
//  EventsViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import DateKit
import Async

class EventsViewController: UIViewController {

    weak var aView: EventsListView?
    var viewModel: ListViewModel<CalendarEntry>?
    var query = EventsQuery(calendarID: Room[0])
    
    let sortingKey = "shortDate"
    let roomSegmentedControl = UISegmentedControl(items: Room.names)

    override func loadView() {
        aView = loadViewWithClass(EventsListView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (aView?.tableView.tableHeaderView as ButtonView).button.addTarget(self, action: Selector("didTapFutureButton:"))
        (aView?.tableView.tableFooterView as ButtonView).button.addTarget(self, action: Selector("didTapPastButton:"))
        
        self.setupRoomSegmentedControl()
        self.setupTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isMovingToParentViewController() {
            roomSegmentedControl.selectedSegmentIndex = 1
            segmentedControlChangedState(roomSegmentedControl)
        } else {
            self.aView?.tableView.deselectRowIfSelectedAnimated(true)
        }
    }
}

// MARK: Requests

extension EventsViewController {
    
    func fetchEventsForCalendars(calendars: [String], completion: (() -> Void)? = nil) {
        
        runActivityIndicator()
        
        let queries: [PageableQuery] = EventsQuery.queries(calendars).map { self.setupQuery($0) }
        NetworkManager.sharedInstance.chainedRequest(queries, construct: { (query, response: [Event]?) -> [CalendarEntry] in
            
            if let query = query as? EventsQuery {
                if let response = response {
                    let events = response.filter { !$0.isCanceled() }
                    return CalendarEntry.caledarEntries(query.calendarID, events: response)
                }
            }
            return []

        }, success: { (result: [CalendarEntry]?) -> () in
            Async.background {
                if let calendarEntries = result {
                    let sortedEntries = CalendarEntry.sortedByDate(calendarEntries)
                    let entriesWithGaps = CalendarEntry.entriesWithFreeGaps(sortedEntries)
                    self.viewModel = ListViewModel(entriesWithGaps, sortingKey: "event.shortDate")
                }
            }.main {
                self.stopActivityIndicator()
                self.aView?.tableView.reloadData()
                if let _completion = completion { _completion() }
            }
            return

        }, failure: { (error) -> () in
            self.stopActivityIndicator()
            UIAlertView(error: error).show()
        })
    }
    
    private func runActivityIndicator() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.color = UIColor.ngOrangeColor()
        indicator.startAnimating()
        self.navigationItem.titleView = indicator
    }
    
    private func stopActivityIndicator() {
        self.navigationItem.titleView = self.roomSegmentedControl
    }
}

// MARK: Actions

extension EventsViewController {

    func segmentedControlChangedState(sender: UISegmentedControl) {
        let index = roomSegmentedControl.selectedSegmentIndex
        
        if index == 0 {
            fetchEventsForCalendars([Room.Aqua, Room.Middle, Room.Cold, Room.DD]) {
                self.aView?.tableView.scrollToTopAnimated(false); return
            }
        } else {
            fetchEventsForCalendars([Room[index]])  {
                self.aView?.tableView.scrollToTopAnimated(false); return
            }
        }
    }
    
    func didTapFutureButton(sender: UIButton) {
        if let maxTime = query.timeMax {
            query.timeMax = maxTime.days + 1
        }
        
        let index = roomSegmentedControl.selectedSegmentIndex
        fetchEventsForCalendars([Room[index]])
    }
    
    func didTapPastButton(sender: UIButton) {
        if let minTime = query.timeMin {
            query.timeMin = minTime.days - 1
        }
        
        let index = roomSegmentedControl.selectedSegmentIndex
        fetchEventsForCalendars([Room[index]])
    }
}

// MARK: UITableViewDelegate

extension EventsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let controller = EventDetailsViewController(event: eventFromIndexPath(indexPath))
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let freeEventCell = cell as? FreeEventCell {
            freeEventCell.invalidate()
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let freeEventCell = cell as? FreeEventCell {
            freeEventCell.invalidate()
        }
    }
}

// MARK: UITableViewDataSource

extension EventsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel?.sectionsCount() ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _section: List<CalendarEntry> = viewModel?[section] {
            return _section.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let event = eventFromIndexPath(indexPath)
        
        if let freeEvent = event as? FreeEvent {
            let cell: FreeEventCell = tableView.dequeueReusableCellWithIdentifier(FreeEventCell.reuseIdentifier) as FreeEventCell
            let minutes = freeEvent.duration/60
            let title = "Book \(Int(minutes)) min"
            
            cell.delegate = self
            cell.timePeriod = freeEvent.duration
            cell.freeTimeButton.setTitle(title)
            
            return cell
        } else {
            let cell: EventCell = tableView.dequeueReusableCellWithIdentifier(EventCell.reuseIdentifier) as EventCell
            cell.textLabel?.text = event?.summary
            cell.timeMaxLabel.text = event?.startTime
            cell.timeMinLabel.text = event?.endTime
            
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let entry = viewModel?[indexPath.section][indexPath.row] {
            if entry.event is FreeEvent {
                return 40.0
            }
        }
        return 65
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = HeaderLabel()
        label.text = (viewModel?[section] as Section).title
        return label
    }
}

// MARK: FreeEventCellDelegate

extension EventsViewController: FreeEventCellDelegate {
 
    func eventCell(cell: FreeEventCell, didChoseTimePeriod timePeriod: NSTimeInterval) {
        if let indexPath = aView?.tableView.indexPathForCell(cell) {
            if let freeEntry = viewModel?[indexPath.section][indexPath.row] {
                let timeFrame = TimeFrame(freeEvent: freeEntry.event as FreeEvent)
                let calendarTime: CalendarTimeFrame = (timeFrame, freeEntry.calendarID)
                
                let confirmationViewController = BookingConfirmationViewController(calendarTime) { (actualCalendarTime) in
                    // NGRTodo: Present success view
                }
                
                let navigationController = NavigationController(rootViewController: confirmationViewController)
                presentViewController(navigationController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: Private

extension EventsViewController {
    
    private func eventFromIndexPath(indexPath: NSIndexPath) -> Event? {

        if viewModel?.sectionsCount() > 1 {
            return viewModel?[indexPath.section][indexPath.row].event
        }
        return viewModel?[indexPath.row].event
    }
    
    private func setupQuery(query: EventsQuery) -> EventsQuery {
        query.maxResults = 100
        query.singleEvents = true
        query.orderBy = "startTime"
        query.timeMax = NSDate().tomorrow.hour(23).minute(59).second(59).date
        query.timeMin = NSDate().midnight
        return query
    }
    
    private func setupRoomSegmentedControl() {
        roomSegmentedControl.addTarget(self, action: Selector("segmentedControlChangedState:"), forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = roomSegmentedControl
    }
    
    private func setupTableView() {
        let tableView: UITableView? = aView?.tableView
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.registerClass(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
        tableView?.registerClass(FreeEventCell.self, forCellReuseIdentifier: FreeEventCell.reuseIdentifier)
    }
}
