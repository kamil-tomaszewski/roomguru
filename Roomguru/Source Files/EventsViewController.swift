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
    var viewModel: ListViewModel<Event>?
    var query: EventsQuery = EventsQuery(calendarID: Room[0])
    
    let sortingKey = "shortDate"
    let roomSegmentedControl = UISegmentedControl(items: Room.names)

    override func loadView() {
        aView = loadViewWithClass(EventsListView.self) as? EventsListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = aView?.tableView
        tableView?.tableHeaderView = buttonView(NSLocalizedString("Future", comment: ""), action: Selector("didTapFutureButton:"))
        tableView?.tableFooterView = buttonView(NSLocalizedString("Past", comment: ""), action: Selector("didTapPastButton:"))
        
        self.setupQuery(Room[0])
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
    
    func fetchEventsForCalendars(calendars: [String]) {
        
        var events: [Event] = []
        
        let failure: (error: NSError) -> () = { (error) -> () in
            UIAlertView(error: error).show()
        }
        
        runActivityIndicator()
        
        let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        let group: dispatch_group_t = dispatch_group_create();
        
        for calendarID in calendars {
            dispatch_group_enter(group)
            
            let query = self.query.copy(calendarID: calendarID)
            NetworkManager.sharedInstance.requestList(query, success: { (response: [Event]?) -> () in
                if let _response = response {
                    // add only not canceled events:
                    events += _response.filter { !$0.isCanceled() }
                }
                dispatch_group_leave(group)
                
            }, failure: { (error) -> () in
                self.stopActivityIndicator()
                dispatch_group_leave(group)
                failure(error: error)
            })
        }
        
        dispatch_group_notify(group, queue) {
            let sortedEvents = Event.sortedByDate(events)
            let eventsWithGaps = FreeEvent.eventsWithFreeGaps(sortedEvents)
            self.viewModel = ListViewModel(eventsWithGaps, sortingKey: "shortDate")
            Async.main {
                self.stopActivityIndicator()
                self.aView?.tableView.reloadData()
            }
        }
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
            fetchEventsForCalendars([Room.Aqua, Room.Middle, Room.Cold, Room.DD])
        } else {
            fetchEventsForCalendars([Room[index]])
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
        if let _section: List<Event> = viewModel?[section] {
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
            cell.invalidate()
            
            return cell
        } else {
            let cell: EventCell = tableView.dequeueReusableCellWithIdentifier(EventCell.reuseIdentifier) as EventCell
            cell.indentationLevel = 7
            cell.textLabel?.text = event?.summary
            cell.timeMaxLabel.text = event?.startTime
            cell.timeMinLabel.text = event?.endTime
            
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let event = viewModel?[indexPath.section][indexPath.row]
        return event is FreeEvent ? 40 : 65
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
            let freeEvent = viewModel?[indexPath.section][indexPath.row]
            
            // book selected room for chosen time period
            
        }
    }
}

// MARK: Private

extension EventsViewController {
    
    private func eventFromIndexPath(indexPath: NSIndexPath) -> Event? {

        if viewModel?.sectionsCount() > 1 {
            return viewModel?[indexPath.section][indexPath.row]
        }
        return viewModel?[indexPath.row]
    }
    
    private func setupQuery(calendarID: String) {
        self.query = EventsQuery(calendarID: calendarID)
        self.query.maxResults = 100
        self.query.singleEvents = true
        self.query.orderBy = "startTime"
        self.query.timeMax = NSDate().tomorrow.hour(23).minute(59).second(59).date
        self.query.timeMin = NSDate().midnight
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
    
    private func buttonView(title: String, action: Selector) -> ButtonView {
        let frame = CGRectMake(0, 0, CGRectGetWidth(aView!.frame), 50)
        
        var buttonView = ButtonView(frame: frame)
        buttonView.button.setTitle(title)
        buttonView.button.addTarget(self, action: action)
        
        return buttonView
    }
}
