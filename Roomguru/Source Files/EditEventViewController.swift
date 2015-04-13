//
//  EditEventViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation


class EditEventViewController: UIViewController {
    
    weak var aView: GroupedBaseTableView?
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
        self.title = controllersTitleForEvent(event)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        aView = loadViewWithClass(GroupedBaseTableView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
        setupTableView()
    }
    
    // MARK: Private
    
    private var event: Event = Event()
}

// MARK: UITableViewDataSource

extension EditEventViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "")
        cell.textLabel?.text = "Placeholder"
        return cell
    }
}

// MARK: UITableViewDelegate

extension EditEventViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

// MARK: Private

private extension EditEventViewController {
    
    // MARK: Configuration
    
    private func setupTableView() {
        let tableView = aView?.tableView
        
        tableView?.dataSource = self
        tableView?.delegate = self
    }
    
    private func setupBarButtons() {
        let dismissSelector = Selector("dismissSelf:")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: dismissSelector)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: dismissSelector)
    }
    
    private func controllersTitleForEvent(event: Event) -> String {
        if let eventID = event.identifier {
            return NSLocalizedString("Edit Event", comment: "")
        }
        return NSLocalizedString("New Event", comment: "")
    }
}

