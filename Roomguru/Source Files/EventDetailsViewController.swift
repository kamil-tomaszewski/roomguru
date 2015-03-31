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
    private let viewModel: EventDetailsViewModel
    
    // MARK: View life cycle
    
    init(event: Event?) {
        self.viewModel = EventDetailsViewModel(event: event)
        super.init(nibName: nil, bundle: nil);
    }

    required init(coder aDecoder: NSCoder) {
        self.viewModel = EventDetailsViewModel(event: nil)
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        aView = loadViewWithClass(EventDetailsView.self) as? EventDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideBackBarButtonTitle()
        self.title = NSLocalizedString("Event Details", comment: "")
        
        aView?.tableView.delegate = self;
        aView?.tableView.dataSource = self;
        aView?.tableView.registerClass(AttendeeCell.self, forCellReuseIdentifier: AttendeeCell.reuseIdentifier)
        aView?.tableView.registerClass(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.reuseIdentifier)
        aView?.tableView.registerClass(TableButtonCell.self, forCellReuseIdentifier: TableButtonCell.reuseIdentifier)
    }
}

// MARK: UITableViewDelegate

extension EventDetailsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

// MARK: UITableViewDataSource

extension EventDetailsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3: return viewModel.numberOfGuests()
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            let _cell = tableView.dequeueReusableCellWithIdentifier(DescriptionCell.reuseIdentifier) as DescriptionCell
            _cell.textLabel?.attributedText = viewModel.summary()
            
            cell = _cell
            
        case 1...3:
            let _cell = tableView.dequeueReusableCellWithIdentifier(AttendeeCell.reuseIdentifier) as AttendeeCell
            let info = attendeeInfoForIndexPath(indexPath)
            
            _cell.headerLabel.text = info.name
            _cell.footerLabel.text = info.email
            _cell.setMarkWithStatus(info.status)
            cell = _cell
            
        case 4:
            let _cell = tableView.dequeueReusableCellWithIdentifier(TableButtonCell.reuseIdentifier) as TableButtonCell
            _cell.button.setTitle(NSLocalizedString("Make a hangout call", comment: ""))
            _cell.button.addTarget(self, action: "didTapHangoutButton:", forControlEvents: .TouchUpInside)
            _cell.button.backgroundColor = UIColor.ngOrangeColor()
            cell = _cell
            
        default:
            cell = UITableViewCell()
            assert(false, "Provide enought data for cell")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            let width = CGRectGetWidth(self.view.frame) - 2 * DescriptionCell.margins().H
            return viewModel.summary().boundingHeightUsingAvailableWidth(width) + 2 * DescriptionCell.margins().V
        default:
            return 61
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0
        default:
            return 30
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = HeaderLabel()
        
        switch section {
        case 1: label.text = NSLocalizedString("Location", comment: "")
        case 2: label.text = NSLocalizedString("Organizer", comment: "")
        case 3: label.text = NSLocalizedString("Guests", comment: "")
        case 4: label.text = NSLocalizedString("Possibilities", comment: "")
        default:
            label.text = nil
        }
        return label
    }
}

// MARK: UIControl Methods

extension EventDetailsViewController {
    
    func didTapHangoutButton(sender: UIButton) {
        println("start hangout call")
    }
}

// MARKL Private

private extension EventDetailsViewController {
    
    private func attendeeInfoForIndexPath(indexPath: NSIndexPath) -> AttendeeInfo {
        if indexPath.section == 1 {
            return viewModel.location(indexPath.row)
        } else if indexPath.section == 2 {
            return viewModel.owner()
        } else {
            return viewModel.attendee(indexPath.row)
        }
    }
}
