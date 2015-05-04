//
//  CalendarPickerViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 01/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import SwiftyJSON

class CalendarPickerViewController: UIViewController {
        
    private weak var aView: CalendarPickerView?
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
        
        if isModal() {
            setSelectAllBarButton()
        }
        setupTableView()
        setBarButtonItemState()
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

private extension CalendarPickerViewController {
    
    func loadData() {
        
        NetworkManager.sharedInstance.request(CalendarsQuery(), success: { [weak self] response in
            
            let calendars = Calendar.map(response?["items"].array)?.filter { $0.isResource() }
            
            if let calendars = calendars where calendars.count > 0 {
                self?.viewModel = CalendarPickerViewModel(calendars: calendars)
                self?.aView?.tableView.reloadData()
                self?.setBarButtonItemState()
            } else {
                
                if let this = self where this.isModal() {
                    this.setSignOutBarButton()
                }
                
                let title = NSLocalizedString("Oh no!", comment: "")
                let message = NSLocalizedString("No resource calendars were find. Please add resource calendars to your Google account.", comment: "")
                UIAlertView(title: title, message: message).show()
            }
            
        }, failure: { error in
            let title = NSLocalizedString("Oh no!", comment: "")
            UIAlertView(title: title, message: error.localizedDescription).show()
        })
    }
    
    func setSignOutBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Sign out", comment: ""), style: .Plain, target: self, action: Selector("didTapSignOutBarButtonItem:"))
    }
    
    func setSelectAllBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Select All", comment: ""), style: .Plain, target: self, action: Selector("didTapSelectAllBarButtonItem:"))
    }
}

// MARK: UITableViewDataSource

extension CalendarPickerViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count() ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(CalendarPickerCell.self)
        
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
        
        if let indexPath = currentEditingIndexPath {
            viewModel?.saveNameForCalendarAtIndexWithSelection(indexPath.row, name: name)
            aView?.tableView.reloadAndDeselectRowAtIndexPath(indexPath)
            setBarButtonItemState()
        }
        currentEditingIndexPath = nil
    }
    
    func calendarNameCustomizerViewControllerDidResetName(controller: CalendarNameCustomizerViewController) {
        
        if let indexPath = currentEditingIndexPath {
            viewModel?.resetCustomCalendarNameAtIndex(indexPath.row)
            aView?.tableView.reloadAndDeselectRowAtIndexPath(indexPath)
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
    
    func didTapSelectAllBarButtonItem(sender: UIBarButtonItem) {
        viewModel?.selectAll()
        setBarButtonItemState()
        aView?.tableView.reloadData()
    }
    
    func didTapSignOutBarButtonItem(sender: UIBarButtonItem) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).signOut()        
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func setupTableView() {
        aView?.tableView.dataSource = self;
        aView?.tableView.delegate = self;
        aView?.tableView.registerClass(CalendarPickerCell.self)
    }
}
