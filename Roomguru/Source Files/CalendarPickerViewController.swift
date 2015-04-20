//
//  CalendarPickerViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 01/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CalendarPickerViewController: UIViewController {
        
    weak var aView: CalendarPickerView?
    var viewModel: CalendarPickerViewModel?
    private var currentEditingIndexPath: NSIndexPath?
    
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
        
        NetworkManager.sharedInstance.calendarsList { [weak self] (calendars, error) in
            
            if let error = error {
                // NGRTodo: handle error
            } else if let calendars = calendars {
                self?.viewModel = CalendarPickerViewModel(calendars: calendars)
                self?.aView?.tableView.reloadData()
                self?.setBarButtonItemState()
            }
        }
    }
}

// MARK: UITableViewDataSource

extension CalendarPickerViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count() ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CalendarPickerCell.reuseIdentifier()) as! CalendarPickerCell
        
        let strings = viewModel?.textForCalendarAtIndex(indexPath.row)
        cell.headerLabel.text = strings?.mainText
        cell.footerLabel.text = strings?.detailText
        cell.checkmarkLabel.hidden = !viewModel!.shouldSelectCalendarAtIndex(indexPath.row)
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension CalendarPickerViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        viewModel?.selectOrDeselectCalendarAtIndex(indexPath.row)
        setBarButtonItemState()
        tableView.reloadAndDeselectRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CalendarPickerCell
        let controller = CalendarNameCustomizerViewController(name: cell.headerLabel.text, indexPath: indexPath)
        controller.delegate = self
        controller.shouldShowResetButton = viewModel?.hasCalendarAtIndexCustomizedName(indexPath.row) ?? false
        currentEditingIndexPath = indexPath
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: CalendarNameCustomizerViewControllerDelegate

extension CalendarPickerViewController: CalendarNameCustomizerViewControllerDelegate {
    
    func calendarNameCustomizerViewController(controller: CalendarNameCustomizerViewController, didEndEditngWithNewName name: String?) {
        
        if let _indexPath = currentEditingIndexPath {
            viewModel?.saveNameForCalendarAtIndexWithSelection(_indexPath.row, name: name)
            aView?.tableView.reloadAndDeselectRowAtIndexPath(_indexPath)
        }
        currentEditingIndexPath = nil
    }
    
    func calendarNameCustomizerViewControllerDidResetName(controller: CalendarNameCustomizerViewController) {
        
        if let _indexPath = currentEditingIndexPath {
            viewModel?.resetCustomCalendarNameAtIndex(_indexPath.row)
            aView?.tableView.reloadAndDeselectRowAtIndexPath(_indexPath)
        }
        currentEditingIndexPath = nil
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
        aView?.tableView.registerClass(CalendarPickerCell.self, forCellReuseIdentifier: CalendarPickerCell.reuseIdentifier())
    }
}
