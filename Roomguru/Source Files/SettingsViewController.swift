//
//  SettingsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    weak var aView: SettingsView?
    private let viewModel = SettingsViewModel(items: [
        SettingItem(NSLocalizedString("Receive notifications", comment: ""), .switchType, "notificationSwitchHandler:"),
        SettingItem(NSLocalizedString("Manage calendars", comment: ""), .noneType, "manageCalendars")
    ])
    
    // MARK: View life cycle

    override func loadView() {
        aView = loadViewWithClass(SettingsView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Sign out", comment: ""), style: .Plain, target: self, action: Selector("didTapSignOutButton:"))
    }
}

// MARK: UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell;
        let item = viewModel[indexPath.row]
        
        if item.type == .switchType {
            cell = self.tableView(tableView, switchCellForItem: item)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(item.signature().identifier) as! UITableViewCell
        }

        cell.textLabel?.text = item.title
        
        return cell
    }
}

//MARK: UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        viewModel[indexPath.row].performActionWithTarget(self)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return viewModel[indexPath.row].selectable()
    }
}

//MARK: Private

private extension SettingsViewController {
    
    func setupTableView() {
        
        aView?.tableView.delegate = self;
        aView?.tableView.dataSource = self;
        
        for (identifier, theClass) in viewModel.signatures() {
            aView?.tableView.registerClass(theClass, forCellReuseIdentifier: identifier)
        }
    }
    
    func notificationSwitchHandler(sender: UISwitch) {
        Settings.reverseNotificationEnabled()
    }
    
    func manageCalendars() {
        navigationController?.pushViewController(CalendarPickerViewController(), animated: true)
    }
    
    func tableView(tableView: UITableView, switchCellForItem item: SettingItem) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(item.signature().identifier) as! SwitchCell
        cell.switchControl.addTarget(self, action: Selector(item.action), forControlEvents: .ValueChanged)
        cell.switchControl.setOn(Settings.isNotifcationEnabled(), animated: false)
        
        return cell
    }
}

//MARK: UIControl methods

extension SettingsViewController {
    
    func didTapSignOutButton(sender: UIBarButtonItem) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).signOut()
    }
}
