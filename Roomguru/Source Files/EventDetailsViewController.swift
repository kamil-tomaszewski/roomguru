//
//  EventDetailsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import AFNetworking

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
        aView = loadViewWithClass(EventDetailsView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideBackBarButtonTitle()
        self.title = NSLocalizedString("Event Details", comment: "")
        setupTableView()
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
        case 1: return viewModel.numberOfLocations()
        case 3: return viewModel.numberOfGuests()
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(DescriptionCell.reuseIdentifier) as DescriptionCell
            cell.textLabel?.attributedText = viewModel.summary()
            
            return cell
            
        case 1...3:
            let cell = tableView.dequeueReusableCellWithIdentifier(AttendeeCell.reuseIdentifier) as AttendeeCell
            let info = attendeeInfoForIndexPath(indexPath)
            
            cell.headerLabel.text = info.name
            cell.footerLabel.text = info.email
            cell.setMarkWithStatus(info.status)

            // hide for locations:
            cell.footerLabel.hidden = (indexPath.section == 1)
            
            if let url = NSURL.gravatarURLWithEmail(info.email) {
                cell.avatarImageView.setImageWithURL(url)
            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(TableButtonCell.reuseIdentifier) as TableButtonCell
            cell.button.setTitle(NSLocalizedString("Join Hangout meeting!", comment: ""))
            cell.button.addTarget(self, action: "didTapHangoutButton:")
            cell.button.backgroundColor = UIColor.ngOrangeColor()
            
            return cell
        }
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
        case 3: label.text = NSLocalizedString("Participants", comment: "")
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
        
        UIApplication.openURLIfPossible(viewModel.hangoutURL()) { (success, error) in
            if let _error = error {
                UIAlertView(error: _error).show()
            }
        };
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
    
    private func setupTableView() {
        aView?.tableView.delegate = self;
        aView?.tableView.dataSource = self;
        aView?.tableView.registerClass(AttendeeCell.self, forCellReuseIdentifier: AttendeeCell.reuseIdentifier)
        aView?.tableView.registerClass(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.reuseIdentifier)
        aView?.tableView.registerClass(TableButtonCell.self, forCellReuseIdentifier: TableButtonCell.reuseIdentifier)
    }
}
