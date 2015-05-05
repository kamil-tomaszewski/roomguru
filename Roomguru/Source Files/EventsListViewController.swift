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
    private var revocable = false

    convenience init(date: NSDate, calendarIDs: [String], revocable: Bool) {
        self.init()
        self.revocable = revocable
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
    
    func revokeEventAtIndexPath(indexPath: NSIndexPath){
        if let event = viewModel?.eventAtIndex(indexPath){
            BookingManager.revokeEvent(event, success: {
                self.viewModel?.removeAtIndexPath(indexPath)
                self.aView?.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }, failure: { error in
                    UIAlertView(error: error).show()
            })
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
        
        if revocable{
            cell = tableView.dequeueReusableCell(RevocableEventCell.self)
            configureRevocableEventCell(cell as! RevocableEventCell, forEvent: event!, andIndexPath: indexPath)
        } else {
            if let freeEvent = event as? FreeEvent {
                cell = tableView.dequeueReusableCell(FreeEventCell.self)
                configureFreeEventCell(cell as! FreeEventCell, forEvent: freeEvent)
            } else {
                cell = tableView.dequeueReusableCell(EventCell.self)
                configureEventCell(cell as! EventCell, forEvent: event!)
            }
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
    
    func configureEventCell(cell: EventCell, forEvent event: Event) {
        cell.textLabel?.text = event.summary
        cell.timeMinLabel.text = event.startTime
        cell.timeMaxLabel.text = event.endTime
    }
    
    func configureRevocableEventCell(cell: RevocableEventCell, forEvent event: Event, andIndexPath indexPath: NSIndexPath) {
        cell.textLabel?.text = event.summary
        cell.timeMinLabel.text = event.startTime
        cell.timeMaxLabel.text = event.endTime
        cell.revokeButtonHandler = { [weak self] in
            self?.revokeEventAtIndexPath(indexPath)}
    }
}

// MARK: Private

private extension EventsListViewController {
    
    func setupTableView() {

        aView?.tableView.dataSource = self
        aView?.tableView.delegate = self

        aView?.tableView.registerClass(EventCell.self)
        aView?.tableView.registerClass(FreeEventCell.self)
        aView?.tableView.registerClass(RevocableEventCell.self)
    }
    
    func loadData() {
   
        eventsProvider.provideCalendarEntriesForCalendarIDs(calendarIDs, timeRange: date.dayTimeRange(), onlyRevocable:revocable) { [weak self] (calendarEntries, error) in
            
            if let error = error {
                self?.aView?.placeholderView.text = NSLocalizedString("Sorry, something went wrong.\n\nA team of highly trained monkeys has been dispatched to deal with this situation.\n\nTo reload, tap on the room name located on the navigation bar.", comment: "")
                self?.aView?.placeholderView.hidden = false
                
            } else if calendarEntries.isEmpty {
                self?.aView?.placeholderView.hidden = false
                
            } else {
                self?.viewModel = EventsListViewModel(calendarEntries, sortingKey: "event.shortDate")
                self?.aView?.tableView.reloadData()
                fade(.In, self?.aView?.tableView, duration: 0.5) { }
            }
        }
    }
}
