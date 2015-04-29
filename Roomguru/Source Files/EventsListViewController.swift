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

class EventsListViewController: UIViewController {

    weak var aView: EventsListView?
    var viewModel: CalendarListViewModel<CalendarEntry>?
    var query = EventsQuery(calendarID: Room.DD)
    var timeMax: NSDate = NSDate()
    var timeMin: NSDate = NSDate()
    var selectedIndexPaths = [NSIndexPath]()

    let sortingKey = "shortDate"

    convenience init(date: NSDate) {
        self.init()
        self.timeMax = date.hour(23).minute(59).second(59).date
        self.timeMin = date.midnight
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
        
        fetchEventsForCalendars([Room.Aqua, Room.Middle, Room.Cold, Room.DD])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isMovingToParentViewController() {
            self.aView?.tableView.deselectRowIfSelectedAnimated(true)
        }
    }
}

// MARK: Requests

extension EventsListViewController {
    
    func fetchEventsForCalendars(calendars: [String], completion: (() -> Void)? = nil) {
        
        let queries: [PageableQuery] = EventsQuery.queries(calendars).map { self.setupQuery($0) }
        NetworkManager.sharedInstance.chainedRequest(queries, construct: { (query, response: [Event]?) -> [CalendarEntry] in
            
            if let query = query as? EventsQuery {
                if let response = response {
                    let events = self.filterEvents(response)
                    return CalendarEntry.caledarEntries(query.calendarID, events: events)
                }
            }
            return []

        }, success: { (result: [CalendarEntry]?) -> Void in
            Async.background {
                if let calendarEntries = result {
                    let properEntries = self.createProperCalendarEntries(calendarEntries)
                    self.viewModel = CalendarListViewModel(properEntries, sortingKey: "event.shortDate")
                }
            }.main {
                self.aView?.tableView.reloadData()
                if let _completion = completion { _completion() }
            }
            return

        }, failure: { error in
            UIAlertView(error: error).show()
        })
    }
}

// MARK: Filtering

extension EventsListViewController {
    
    func filterEvents (events: [Event]) -> [Event] {
        return events.filter{ !$0.isCanceled() }
    }
    
    func createProperCalendarEntries (entries: [CalendarEntry]) -> [CalendarEntry] {
        let sortedEntries = CalendarEntry.sortedByDate(entries)
        return CalendarEntry.entriesWithFreeGaps(sortedEntries)
    }
    
}

// MARK: UITableViewDelegate

extension EventsListViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let event = eventFromIndexPath(indexPath)
        
        if let freeEvent = event as? FreeEvent {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! FreeEventCell
            tableView.deselectRowIfSelectedAnimated(true)
            println("already selected indexPaths: \(self.selectedIndexPaths)")
            if contains(self.selectedIndexPaths, indexPath) { //This cell is already selected
                println("deselecting cell @ \(indexPath)")
                if let index = find(self.selectedIndexPaths, indexPath) {
                    self.selectedIndexPaths.removeAtIndex(index)
                }
            } else {
                if self.selectedIndexPaths.isEmpty {
                    cell.toggleState(animated: true)
                } else {
                    if (shouldAllowSelection(indexPath)) {
                        cell.toggleState(animated: true)
                    }
                }
                self.selectedIndexPaths.append(indexPath)
            }
            return
        }

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

extension EventsListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?[section].count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let event = eventFromIndexPath(indexPath)
        
        if let freeEvent = event as? FreeEvent {
            let cell = tableView.dequeueReusableCell(FreeEventCell.self)
            let minutes = freeEvent.duration/60
            let title = "Book \(Int(minutes)) min"
            
            cell.delegate = self
            cell.timePeriod = freeEvent.duration
//            cell.freeTimeButton.setTitle(title)
            
            cell.timeMaxLabel.text = event?.startTime
            cell.timeMinLabel.text = event?.endTime
            
            return cell
        } else {
            let cell: EventCell = tableView.dequeueReusableCell(EventCell.self)
            cell.textLabel?.text = event?.summary
            cell.timeMaxLabel.text = event?.startTime
            cell.timeMinLabel.text = event?.endTime
            
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return viewModel?[indexPath.row]?.event is FreeEvent ? 40 : 65
    }
}

// MARK: FreeEventCellDelegate

extension EventsListViewController: FreeEventCellDelegate {
 
    func eventCell(cell: FreeEventCell, didChoseTimePeriod timePeriod: NSTimeInterval) {
        if let indexPath = aView?.tableView.indexPathForCell(cell) {


            
//            if let freeEntry = viewModel?[indexPath.section][indexPath.row] {
//                let timeFrame = TimeFrame(freeEvent: freeEntry.event as! FreeEvent)
//                let calendarTime: CalendarTimeFrame = (timeFrame, freeEntry.calendarID)
//                
//                let confirmationViewController = BookingConfirmationViewController(calendarTime) { (actualCalendarTime) in
//                    // NGRTodo: Present success view
//                }
//                
//                let navigationController = NavigationController(rootViewController: confirmationViewController)
//                presentViewController(navigationController, animated: true, completion: nil)
//            }
        }
    }
}

// MARK: Private

extension EventsListViewController {
    
    private func eventFromIndexPath(indexPath: NSIndexPath) -> Event? {

        if viewModel?.sectionsCount() > 1 {
            return viewModel?[indexPath.section][indexPath.row].event
        }
        return viewModel?[indexPath.row]?.event
    }
    
    private func shouldAllowSelection(indexPath: NSIndexPath) -> Bool {
        let nextIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        let previousIndexPathSection = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
        
        if  contains(self.selectedIndexPaths, nextIndexPath) ||
            contains(self.selectedIndexPaths, previousIndexPathSection) {
            return true
        } else {
            return false
        }
    }

    
    private func setupQuery(query: EventsQuery) -> EventsQuery {
        query.maxResults = 100
        query.singleEvents = true
        query.orderBy = "startTime"
        query.timeMax = timeMax
        query.timeMin = timeMin
        return query
    }
    
    func setupTableView() {
        let tableView: UITableView? = aView?.tableView
        
        tableView?.dataSource = self
        tableView?.delegate = self

        tableView?.registerClass(EventCell.self)
        tableView?.registerClass(FreeEventCell.self)
    }
}

class RevokeEventsViewController: EventsListViewController {
    
    override func filterEvents(events: [Event]) -> [Event] {
        let userEmail = UserPersistenceStore.sharedStore.user?.email
        return events.filter { !$0.isCanceled() && $0.creator?.email == userEmail }
    }
    
    override func createProperCalendarEntries(entries: [CalendarEntry]) -> [CalendarEntry] {
        return CalendarEntry.sortedByDate(entries)
    }
    
    override func setupTableView() {
        super.setupTableView()
        aView?.tableView.registerClass(RevocableEventCell.self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = eventFromIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(RevocableEventCell.self)
        cell.textLabel?.text = event?.summary
        cell.timeMaxLabel.text = event?.startTime
        cell.timeMinLabel.text = event?.endTime
        cell.revokeButtonHandler = { [weak self] in
            self?.revokeEventAtIndexPath(indexPath)}
        return cell
    }
    
    func revokeEventAtIndexPath(indexPath: NSIndexPath){
        if let event = eventFromIndexPath(indexPath){
        BookingManager.revokeEvent(event, success: {
            self.viewModel?.removeAtIndexPath(indexPath)
            self.aView?.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }, failure: { error in
                UIAlertView(error: error).show()
            })
        }
    }
}
