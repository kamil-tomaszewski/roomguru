//
//  EventDetailsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    weak var aView: EventDetailsView?
    private var event: Event?
    
    // MARK: View life cycle
    
    init(event: Event?) {
        self.event = event
        super.init(nibName: nil, bundle: nil);
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        aView = loadViewWithClass(EventDetailsView.self) as? EventDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.event?.summary
        
        aView?.tableView.delegate = self;
        aView?.tableView.dataSource = self;
        aView?.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "any") //temporary
    }
}

// MARK: UITableViewDelegate

extension EventDetailsViewController: UITableViewDelegate {
    
}

// MARK: UITableViewDataSource

extension EventDetailsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("any") as UITableViewCell  //temporary
        cell.textLabel?.text = event?.summary;
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65.0
    }
}