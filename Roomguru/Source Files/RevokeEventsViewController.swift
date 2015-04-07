//
//  RevokeEventsViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 02/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Async
import DateKit

class RevokeEventsViewController: UIViewController {

    let calendarsIDs: [String] = [Room.Aqua, Room.Middle, Room.Cold, Room.DD]
    
    weak var aView: EventsListView?
    var viewModel = ListViewModel<CalendarEntry>([], sortingKey: "event.shortDate")

    var timeMax = NSDate()
    var timeMin = NSDate().midnight
    
    // MARK: Lifecycle
    
    override func loadView() {
        aView = loadViewWithClass(EventsListView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        self.title = NSLocalizedString("Revoke events", comment: "")
        
        if self.tabBarController == nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel , target: self, action: Selector("dismissSelf:"))
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fetchEvents(nil)
    }
}

// MARK: Requests

extension RevokeEventsViewController {
    
    func fetchEvents(completion: (() -> ())?) {
        runActivityIndicator()
        
        let queries: [PageableQuery] = EventsQuery.queries(calendarsIDs).map { self.setupQuery($0) }
        NetworkManager.sharedInstance.chainedRequest(queries, construct: { (query, response: [Event]?) -> [CalendarEntry] in
            
            if let query = query as? EventsQuery {
                if let response = response {
                    let events = response.filter { !$0.isCanceled() }
                    return CalendarEntry.caledarEntries(query.calendarID, events: events)
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
                completion?()
                if let completion = completion { completion() }
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
        self.navigationItem.titleView = nil
        self.navigationItem.title = self.title
    }
    
}

// MARK: UITableViewDataSource

extension RevokeEventsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.sectionsCount()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let event = viewModel[indexPath.section][indexPath.row].event
        var cell: EventCell = tableView.dequeueReusableCellWithIdentifier(EventCell.reuseIdentifier) as EventCell
        cell.timeMaxLabel.text = event.startTime
        cell.timeMinLabel.text = event.endTime
        cell.textLabel?.text = event.summary
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = HeaderLabel()
        label.text = (viewModel[section] as Section).title
        return label
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

// MARK: UITableViewDelegate

extension RevokeEventsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let title = NSLocalizedString("Revoke", comment: "")
        let action = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: title, handler: { (action, indexPath) -> Void in
            let calendarEntry = self.viewModel[indexPath.section][indexPath.row]
            BookingManager.revokeCalendarEntry(calendarEntry, success: {
                self.viewModel.removeAtIndexPath(indexPath)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }, failure: { (error) -> () in
                UIAlertView(error: error).show()
            })
        })
        
        action.backgroundColor = UIColor.redColor()
        
        return [action]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}
}

// MARK: Actions

extension RevokeEventsViewController {
    
    func dismissSelf(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func didTapFutureButton(sender: UIButton) {
        timeMax = timeMax.days + 1
        fetchEvents(nil)
    }
    
    func didTapPastButton(sender: UIButton) {
        timeMin = timeMin.days - 1
        fetchEvents(nil)
    }
}

// MARK: Private

private extension RevokeEventsViewController {

    private func setupTableView() {
        let tableView = aView?.tableView
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.registerClass(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
        
        (aView?.tableView.tableHeaderView as ButtonView).button.addTarget(self, action: Selector("didTapPastButton:"))
        (aView?.tableView.tableFooterView as ButtonView).button.addTarget(self, action: Selector("didTapFutureButton:"))
        
        tableView?.allowsMultipleSelectionDuringEditing = false;
    }
    
    private func setupQuery(query: EventsQuery) -> EventsQuery {
        query.maxResults = 100
        query.singleEvents = true
        query.orderBy = "startTime"
        query.timeMax = timeMax
        query.timeMin = timeMin
        return query
    }
}
