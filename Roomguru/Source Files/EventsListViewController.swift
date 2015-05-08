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
    
    private(set) var date = NSDate()

    private let eventsProvider = EventsProvider()
    private weak var aView: EventsListView?
    private var viewModel: EventsListViewModel<CalendarEntry>?
    private var revocable = false

    convenience init(date: NSDate, calendarIDs: [String], revocable: Bool) {
        self.init()
        self.revocable = revocable
        self.date = date
        eventsProvider.calendarIDs = calendarIDs
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
        
        if let freeEvent = event as? FreeEvent {

            viewModel?.selectOrDeselectFreeEventAtIndexPath(indexPath)
            var indexPaths = viewModel?.indexPathsToReload() ?? []
            indexPaths.append(indexPath)
            aView?.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)

        } else {
            let controller = EventDetailsViewController(event: event)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return viewModel?.isSelectableIndex(indexPath) ?? true
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
        let cell = dequeueCellForEvent(event!, inTableView: tableView)
        
        let now = NSDate()
        
        if now.isLaterThan(event!.end) {
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
        return (viewModel?.eventAtIndex(indexPath) is FreeEvent) ? 44 : 60
    }
    
    func dequeueCellForEvent(event: Event, inTableView tableView: UITableView) -> EventCell {
        if revocable {
            return tableView.dequeueReusableCell(RevocableEventCell.self)
        } else if let freeEvent = event as? FreeEvent {
            return tableView.dequeueReusableCell(FreeEventCell.self)
        } else {
            return tableView.dequeueReusableCell(EventCell.self)
        }
    }
}

// MARK: UIControl methods

extension EventsListViewController {
    
    func revokeEventAtIndexPath(indexPath: NSIndexPath) {
        if let event = viewModel?.eventAtIndex(indexPath) {
            
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            PKHUD.sharedHUD.dimsBackground = false
            PKHUD.sharedHUD.contentView.backgroundColor = .rgb(243, 166, 62)
            PKHUD.sharedHUD.show()
           
            BookingManager.revokeEvent(event) { (success, error) in
            
                PKHUD.sharedHUD.hide()
                
                if let error = error {
                    UIAlertView(error: error).show()
                } else {
                    self.viewModel?.removeAtIndexPath(indexPath)
                    self.aView?.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
    
    // NGRTodo: attach book view controller:
    
    func didTapBookButton(sender: UIButton) {
        if let timeRange = viewModel?.selectedTimeRangeToBook() {
            println("min: \(timeRange.min), max: \(timeRange.max)")
            println("selected calendar ID: \(eventsProvider.calendarIDs.first)")
        }
    }
}

private extension EventsListViewController {
    
    // MARK: Cell configuration
    
    func configureCell(cell: EventCell, forEvent event: Event, indexPath: NSIndexPath) {
        
        if cell.isKindOfClass(RevocableEventCell.self) {
            configureRevocableEventCell(cell as! RevocableEventCell, forEvent: event, indexPath: indexPath)
            
        } else if cell.isKindOfClass(FreeEventCell.self)  {
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
        
        if let tuple = viewModel?.isFreeEventSelectedAtIndex(indexPath) {
            cell.contentView.backgroundColor = tuple.selected ? .ngGreenColor() : .ngOrangeColor()
            cell.bookButton.hidden = !tuple.lastUserSelection
        }
    }
    
    func configureEventCell(cell: EventCell, forEvent event: Event) {
        cell.textLabel?.text = event.summary
        cell.timeMinLabel.text = event.startTime
        cell.timeMaxLabel.text = event.endTime
    }
    
    func configureRevocableEventCell(cell: RevocableEventCell, forEvent event: Event, indexPath: NSIndexPath) {
        cell.textLabel?.text = event.summary
        cell.timeMinLabel.text = event.startTime
        cell.timeMaxLabel.text = event.endTime
        cell.revokeButtonHandler = { [weak self] in
            self?.revokeEventAtIndexPath(indexPath)
        }
    }
    
    // MARK:

    func setupTableView() {

        aView?.tableView.dataSource = self
        aView?.tableView.delegate = self

        aView?.tableView.registerClass(EventCell.self)
        aView?.tableView.registerClass(FreeEventCell.self)
        aView?.tableView.registerClass(RevocableEventCell.self)
    }
    
    func loadData() {
        
        if revocable {
            
            eventsProvider.revocableCalendarEntriesForTimeRange(date.dayTimeRange()) { [weak self] (calendarEntries, error) in
                
                if let error = error {
                    self?.showErrorPlaceholder()
                } else {
                    self?.viewModel = EventsListViewModel(calendarEntries)
                    self?.aView?.tableView.reloadData()
                    self?.scrollToNowAnimated(false)
                    fade(.In, self?.aView?.tableView, duration: 0.5) { }
                }
            }
            
        } else {
            
            eventsProvider.calendarEntriesForTimeRange(date.dayTimeRange()) { [weak self] (calendarEntries, error) in
                
                if let error = error {
                    self?.showErrorPlaceholder()
                    
                } else if calendarEntries.isEmpty {
                    self?.aView?.showPlaceholder(text: NSLocalizedString("Weekend day.\nGo away from your computer and relax!", comment: ""))
                    
                } else {
                    self?.viewModel = EventsListViewModel(calendarEntries)
                    self?.aView?.tableView.reloadData()
                    self?.scrollToNowAnimated(false)
                    fade(.In, self?.aView?.tableView, duration: 0.5) { }
                }
            }
        }
    }
    
    func showErrorPlaceholder() {
        let text = NSLocalizedString("Sorry, something went wrong.\n\nA team of highly trained monkeys has been dispatched to deal with this situation.\n\nTo reload, tap on the room name located on the navigation bar.", comment: "")
        aView?.showPlaceholder(withIcon: .MehO, text: text)
    }
    
    func scrollToNowAnimated(animated: Bool) {
        
        let now = NSDate()
        
        if !date.isSameDayAs(now) {
            return
        }
        
        if let path = viewModel?.indexOfItemWithDate(now) {
            let indexPath = NSIndexPath(forRow: path.row, inSection: path.section)
            aView?.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: animated)
        }
    }
}
