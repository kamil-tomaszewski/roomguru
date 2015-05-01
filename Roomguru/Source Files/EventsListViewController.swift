//
//  EventsViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EventsListViewController: UIViewController {
    
    private(set) var date = NSDate()

    private let eventsProvider = EventsProvider()
    private weak var aView: EventsListView?
    private var calendarIDs: [String] = []
    private var viewModel: EventsListViewModel<CalendarEntry>?
    private var selectedIndexPaths = [NSIndexPath]()

    convenience init(date: NSDate, calendarIDs: [String]) {
        self.init()
        self.date = date
        self.calendarIDs = calendarIDs
    }
    
    init() {
        super.init(nibName:nil,bundle:nil)
    }
    
    required init(coder aDecoder: NSCoder) {
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
}

// MARK: UITableViewDelegate

extension EventsListViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let event = viewModel?.eventAtIndex(indexPath)
        let controller = EventDetailsViewController(event: event)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: UITableViewDataSource

extension EventsListViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel?.sectionsCount() ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?[section].count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let event = viewModel?.eventAtIndex(indexPath)
        let cell: UITableViewCell!
        
        if let freeEvent = event as? FreeEvent {
            cell = tableView.dequeueReusableCell(FreeEventCell.self)
            configureFreeEventCell(cell as! FreeEventCell, forEvent: freeEvent)
        } else {
            cell = tableView.dequeueReusableCell(EventCell.self)
            configurEventCell(cell as! EventCell, forEvent: event!)
        }
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if viewModel?.eventAtIndex(indexPath) is FreeEvent {
            return 44
        }
        return 60
    }
}

// MARK: Cell configuration

extension EventsListViewController {
    
    func configureFreeEventCell(cell: FreeEventCell, forEvent event: FreeEvent) {
        let minutes = event.duration/60
        let title = "Book \(Int(minutes)) min"
    
        cell.timePeriod = event.duration
        
        cell.timeMinLabel.text = event.startTime
        cell.timeMaxLabel.text = event.endTime
    }
    
    func configurEventCell(cell: EventCell, forEvent event: Event) {
        cell.textLabel?.text = event.summary
        cell.timeMinLabel.text = event.startTime
        cell.timeMaxLabel.text = event.endTime
    }
}

// MARK: Private

private extension EventsListViewController {
    
    func setupTableView() {

        aView?.tableView.dataSource = self
        aView?.tableView.delegate = self

        aView?.tableView.registerClass(EventCell.self)
        aView?.tableView.registerClass(FreeEventCell.self)
    }
    
    func loadData() {
        
        eventsProvider.provideDataForCalendarIDs(calendarIDs, timeRange: date.dayTimeRange()) { [weak self] (calendarEntries, error) in
            
            if let error = error {
                UIAlertView(error: error).show()
            } else {
                self?.viewModel = EventsListViewModel(calendarEntries, sortingKey: "event.shortDate")
                self?.aView?.tableView.reloadData()
                fade(.In, self?.aView?.tableView, duration: 0.5) { }
            }
        }
    }
}
