//
//  CalendarPickerViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 01/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import StatefulViewController

class CalendarPickerViewController: StatefulViewController {
        
    weak var aView: CalendarPickerView?
    var viewModel: CalendarPickerViewModel?
    
    // MARK: View life cycle
    
    override func loadView() {
        aView = loadViewWithClass(CalendarPickerView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Pick your calendars", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Next", comment: ""), style: .Plain, target: self, action: Selector("didTapNextBarButtonItem:"))
        
        setupTableView()
        setupPlaceholderViewsWithRefreshTarget(self)
        loadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: Private

extension CalendarPickerViewController {
    
    func loadData() {
        
        if (lastState == .Loading) { return }
        
        startLoading()
        NetworkManager.sharedInstance.calendarsList({ (calendars) -> Void in
            self.viewModel = CalendarPickerViewModel(calendars: calendars)
            self.aView?.tableView.reloadData()
            self.setBarButtonItemState()
            self.endLoading()
        }, failure: { (error) -> () in
            self.endLoading(error: NSError())
        })
    }
}

// MARK: UITableViewDataSource

extension CalendarPickerViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel?.calendars.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(UITableViewCellReuseIdentifier) as UITableViewCell
        
        if let calendar = viewModel?.calendars[indexPath.row] {
            cell.textLabel?.text = calendar.summary
            cell.accessoryType = viewModel!.shouldSelectCalendar(calendar) ? .DetailDisclosureButton : .DisclosureIndicator
            cell.tintColor = UIColor.ngOrangeColor()
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension CalendarPickerViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        viewModel?.saveOrRemoveItemAtIndex(indexPath.row)
        setBarButtonItemState()
        tableView.reloadAndDeselectRowAtIndexPath(indexPath)
    }
}

// MARK: StatefulViewControllerDelegate

extension CalendarPickerViewController: StatefulViewControllerDelegate {
    
    func hasContent() -> Bool {
        let isEmpty = viewModel?.calendars.isEmpty ?? true
        aView?.tableView.hidden = isEmpty
        return !isEmpty
    }
}

extension CalendarPickerViewController {
    
    func setBarButtonItemState() {
        self.navigationItem.rightBarButtonItem?.enabled = viewModel?.shouldProcceed() ?? false
    }
    
    func didTapNextBarButtonItem(sender: UIBarButtonItem) {
    
        viewModel?.save()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setupTableView() {
        aView?.tableView.dataSource = self;
        aView?.tableView.delegate = self;
        aView?.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: UITableViewCellReuseIdentifier)
    }
}
