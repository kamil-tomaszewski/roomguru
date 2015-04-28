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
    var query = EventsQuery(calendarID: Room.DD)
    var timeMax: NSDate = NSDate()
    var timeMin: NSDate = NSDate()
    var selectedIndexPaths = [NSIndexPath]()

    
    let sortingKey = "shortDate"
    let roomSegmentedControl = UISegmentedControl(items: Room.names)

    convenience init(date: NSDate){
        self.init()
        timeMax = date.hour(23).minute(59).second(59).date
        timeMin = date.midnight
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
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
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
                    let events = self.filterEvents(response)
                    return CalendarEntry.caledarEntries(query.calendarID, events: events)
                }
            }
            return []

        }, success: { (result: [CalendarEntry]?) -> () in
            Async.background {
                if let calendarEntries = result {
                    let properEntries = self.createProperCalendarEntries(calendarEntries)
                    self.viewModel = ListViewModel(properEntries, sortingKey: "event.shortDate")
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

// MARK: Filtering

extension EventsViewController {
    
    func filterEvents (events: [Event]) -> [Event]{
        return events.filter{ !$0.isCanceled() }
    }
    
    func createProperCalendarEntries (entries: [CalendarEntry]) -> [CalendarEntry]{
        let sortedEntries = CalendarEntry.sortedByDate(entries)
        return CalendarEntry.entriesWithFreeGaps(sortedEntries)
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
            fetchEventsForCalendars([Room.DD])  {
                self.aView?.tableView.scrollToTopAnimated(false); return
            }
        }
    }
}

// MARK: UITableViewDelegate

extension EventsViewController: UITableViewDelegate {

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
            let cell: FreeEventCell = tableView.dequeueReusableCell(FreeEventCell.self)
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
        label.text = (viewModel?[section] as! Section).title
        return label
    }
}

// MARK: FreeEventCellDelegate

extension EventsViewController: FreeEventCellDelegate {
 
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

extension EventsViewController {
    
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
    
    private func setupRoomSegmentedControl() {
        roomSegmentedControl.addTarget(self, action: Selector("segmentedControlChangedState:"), forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = roomSegmentedControl
    }
    
    func setupTableView() {
        let tableView: UITableView? = aView?.tableView
        
        tableView?.dataSource = self
        tableView?.delegate = self

        tableView?.registerClass(EventCell.self)
        tableView?.registerClass(FreeEventCell.self)

    }
}

class RevokeEventsViewController: EventsViewController {
    
    override func filterEvents(events: [Event]) -> [Event] {
        let userEmail = UserPersistenceStore.sharedStore.user?.email
        return events.filter { !$0.isCanceled() && $0.creator?.email == userEmail }
    }
    
    override func createProperCalendarEntries(entries: [CalendarEntry]) -> [CalendarEntry] {
        return CalendarEntry.sortedByDate(entries)
    }
    
    override func setupTableView() {
        super.setupTableView()
        aView?.tableView.registerClass(RevocableEventCell.self, forCellReuseIdentifier: RevocableEventCell.reuseIdentifier())
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = eventFromIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(RevocableEventCell.self)
        cell.textLabel?.text = event?.summary
        cell.timeMaxLabel.text = event?.startTime
        cell.timeMinLabel.text = event?.endTime
        cell.revokeButtonHandler = {self.revokeEventAtIndexPath(indexPath)}
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