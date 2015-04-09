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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .Plain, target: self, action: Selector("didTapSaveBarButtonItem:"))
        
        setupTableView()
        hideBackBarButtonTitle()
        setupPlaceholderViewsWithRefreshTarget(self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isMovingToParentViewController() {
            loadData()
        }
    }
}

// MARK: Private

extension CalendarPickerViewController {
    
    func loadData() {
        
        if (lastState == .Loading) { return }
        
        startLoading()
        NetworkManager.sharedInstance.calendarsList({ (calendars) in
            self.viewModel = CalendarPickerViewModel(calendars: calendars)
            self.aView?.tableView.reloadData()
            self.setBarButtonItemState()
            self.endLoading()
        }, failure: { (error) in
            self.endLoading(error: error)
        })
    }
}

// MARK: UITableViewDataSource

extension CalendarPickerViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.calendars.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CalendarPickerCell.reuseIdentifier) as! CalendarPickerCell
        
        if let calendar = viewModel?.calendars[indexPath.row] {
            let strings = viewModel?.textForCalendar(calendar)
            cell.headerLabel.text = strings?.mainText
            cell.footerLabel.text = strings?.detailText
            cell.checkmarkLabel.hidden = !viewModel!.shouldSelectCalendar(calendar)
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
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CalendarPickerCell
        let controller = CalendarNameCustomizerViewController(name: cell.headerLabel.text, indexPath: indexPath)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
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

// MARK: CalendarNameCustomizerViewControllerDelegate

extension CalendarPickerViewController: CalendarNameCustomizerViewControllerDelegate {
    
    func calendarNameCustomizerViewController(controller: CalendarNameCustomizerViewController, didEndEditngWithNewName name: String?, forIndexPath indexPath: NSIndexPath?) {
        
        if let calendar = viewModel?.calendars[indexPath!.row] {
            calendar.name = name;
            aView?.tableView.reloadAndDeselectRowAtIndexPath(indexPath!)
        }
    }
}

extension CalendarPickerViewController {
    
    func setBarButtonItemState() {
        self.navigationItem.rightBarButtonItem?.enabled = viewModel?.shouldProcceed() ?? false
    }
    
    func didTapSaveBarButtonItem(sender: UIBarButtonItem) {
        viewModel?.save()
        
        if isModal() {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    private func setupTableView() {
        aView?.tableView.dataSource = self;
        aView?.tableView.delegate = self;
        aView?.tableView.registerClass(CalendarPickerCell.self, forCellReuseIdentifier: CalendarPickerCell.reuseIdentifier)
    }
}
