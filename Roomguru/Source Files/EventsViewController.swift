//
//  EventsViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import DateKit

class EventsViewController: UIViewController {

    weak var aView: EventsListView?
    var viewModel: ListViewModel<Event>?
    var query: EventsQuery = EventsQuery(calendarID: Room[0])
    
    let sortingKey = "shortDate"
    let roomSegmentedControl = UISegmentedControl(items: ["All", "Aqua", "Middle", "Cold"])

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
        roomSegmentedControl.selectedSegmentIndex = 1
        segmentedControlChangedState(roomSegmentedControl)
    }
    
}

// MARK: Requests

extension EventsViewController {
    
    func fetchEvents() {
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.startAnimating()
        self.navigationItem.titleView = indicator
        
        NetworkManager.sharedInstance.eventsList(query, success: { (response) -> () in
            
            if let events: [Event] = response {
                let sortedEvents = Event.sortedByDate(events)
                let eventsWithGaps = FreeEvent.eventsWithFreeGaps(sortedEvents)
                
                self.viewModel = ListViewModel(eventsWithGaps, sortingKey: "shortDate")
                self.aView?.tableView.reloadData()
            }
            
            self.navigationItem.titleView = self.roomSegmentedControl
            
            }, failure: { (error) -> () in
                
                UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
                self.navigationItem.titleView = self.roomSegmentedControl
                
        })
    }
    
}

// MARK: Actions

extension EventsViewController {

    func segmentedControlChangedState(sender: UISegmentedControl) {
        let index = roomSegmentedControl.selectedSegmentIndex
        setupQuery(Room[index])
        fetchEvents()
    }
    
    func didTapFutureButton(sender: UIButton) {
        if let maxTime = query.timeMax {
            query.timeMax = maxTime.days + 1
        }
        
        fetchEvents()
    }
    
    func didTapPastButton(sender: UIButton) {
        if let minTime = query.timeMin {
            query.timeMin = minTime.days - 1
        }
        
        fetchEvents()
    }
    
}


// MARK: UITableViewDelegate

extension EventsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("\(__FUNCTION__)")
        println("go to event detail")
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

        let section = indexPath.section
        let row = indexPath.row
        
        var event: Event?
        
        if viewModel?.sectionsCount() > 1 {
            event = viewModel?[section][row]
        } else {
            event = viewModel?[row]
        }
        
        if let freeEvent = event as? FreeEvent {
            let cell: FreeEventCell = tableView.dequeueReusableCellWithIdentifier(FreeEventCell.reuseIdentifier) as FreeEventCell
            let minutes = freeEvent.duration/60
            let title = "Book for \(Int(minutes)) min"
            cell.freeTimeButton.setTitle(title, forState: .Normal)
            return cell
        } else {
            let cell: EventCell = tableView.dequeueReusableCellWithIdentifier(EventCell.reuseIdentifier) as EventCell
            cell.indentationLevel = 7
            cell.textLabel?.text = event?.summary
            cell.timeMaxLabel.text = event?.endTime
            cell.timeMinLabel.text = event?.startTime
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (viewModel?[section] as Section).title
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let event = viewModel?[indexPath.section][indexPath.row]
        if event is FreeEvent {
            return 40.0
        }
        return 65.0
    }
    
}

// MARK: Private

extension EventsViewController {
    
    private func setupQuery(calendarID: String) {
        query = EventsQuery(calendarID: calendarID)
        query.maxResults = 100
        query.singleEvents = true
        query.orderBy = "startTime"
        query.timeMax = NSDate().tomorrow.hour(23).minute(59).second(59).date
        query.timeMin = NSDate().midnight
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
        let tableView = aView?.tableView
        let frame = CGRectMake(0, 0, CGRectGetWidth(aView!.frame), 50)
        
        var buttonView = ButtonView(frame: frame)
        buttonView.button.setTitle(title, forState: .Normal)
        buttonView.button.addTarget(self, action: action)
        
        return buttonView
    }
    
}
