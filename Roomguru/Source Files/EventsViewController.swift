//
//  EventsViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    weak var aView: EventsListView?
    
    var viewModel: ListViewModel<Event>?
    var roomSegmentedControl = UISegmentedControl(items: ["All", "Aqua", "Middle", "Cold"])

    override func loadView() {
        var view = EventsListView(frame: UIScreen.mainScreen().applicationFrame)
        aView = view
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRoomSegmentedControl()
        self.setupTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.startAnimating()
        self.navigationItem.titleView = indicator
        
        let calendarID = "netguru.pl_2d36343438343933352d363234@resource.calendar.google.com"
        NetworkManager.sharedInstance.eventsList(forCalendar: calendarID, success: { (response) -> () in
            let array = response?["items"].array
        
            self.viewModel = ListViewModel<Event>(Event.map(array)!)
            self.aView?.tableView.reloadData()
            
            self.navigationItem.titleView = self.roomSegmentedControl
        }, { (error) -> () in
            UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            self.navigationItem.titleView = self.roomSegmentedControl
        })
    }
    
}

// MARK: Actions

extension EventsViewController {

    func segmentedControlChangedState(sender: UISegmentedControl) {
        println("\(__FUNCTION__): \(sender.selectedSegmentIndex)")
        println("reload table view")
    }
    
}

// MARK: UITableViewDelegate

extension EventsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("\(__FUNCTION__)")
        println("go to event detail")
    }
    
}

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

        let index = indexPath.row
        let summary = viewModel?[index].summary
        
        let reuseIdentifier = "EventCellIdentifier";
        let cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        
        if let _cell: UITableViewCell = cell as? UITableViewCell {
            _cell.textLabel?.text = summary
            return _cell
        } else {
            let basicCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
            basicCell.textLabel?.text = summary
            return basicCell
        }
    }
    
}

// MARK: Private

extension EventsViewController {
    
    private func setupRoomSegmentedControl() {
        roomSegmentedControl.selectedSegmentIndex = 1
        roomSegmentedControl.addTarget(self, action: Selector("segmentedControlChangedState:"), forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = roomSegmentedControl
    }
    
    private func setupTableView() {
        aView?.tableView.dataSource = self
        aView?.tableView.delegate = self
    }
    
}
