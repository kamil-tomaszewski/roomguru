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
    private var viewModel: CalendarPickerViewModel?
    private var currentEditingIndexPath: NSIndexPath?
    
    var saveCompletionBlock: VoidBlock?
    
    // MARK: View life cycle
    
    override func loadView() {
        aView = loadViewWithClass(CalendarPickerView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Pick your calendars", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .Plain, target: self, action: Selector("didTapSaveBarButtonItem:"))
        
        if isModal {
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
                
                if let this = self where this.isModal {
                    this.setSignOutBarButton()
                }
                
                let message = NSLocalizedString("No resource calendars were find. Please add resource calendars to your Google account.", comment: "")
                
                let alertController = UIAlertController(message: message)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Read more", comment: ""), style: .Default) { (action) in
                    UIApplication.sharedApplication().openURL(Constants.Google.ResourceCalendarsURL!)
                })
                
                self?.aView?.loadingSpinner.stopAnimating()
                self?.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }, failure: { error in
            self.presentViewController(UIAlertController(error: error), animated: true, completion: nil)
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
        return viewModel?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(CalendarPickerCell.self)
        
        if let viewModel = viewModel {
            
            let strings = viewModel.textForCalendarAtIndex(indexPath.row)
            cell.headerLabel.text = strings.mainText
            cell.footerLabel.text = strings.detailText
            cell.checkmarkLabel.hidden = !viewModel.shouldSelectCalendarAtIndex(indexPath.row)
            cell.colorView.backgroundColor = viewModel.calendarColorAtIndex(indexPath.row)
        }

        return cell
    }
}

// MARK: UITableViewDelegate

extension CalendarPickerViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        viewModel?.selectOrDeselectCalendarAtIndex(indexPath.row)
        setBarButtonItemState()
        tableView.reloadAndDeselectRowAtIndexPath(indexPath)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CalendarPickerCell
        cell.colorView.backgroundColor = viewModel?.calendarColorAtIndex(indexPath.row)
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CalendarPickerCell
        cell.colorView.backgroundColor = viewModel?.calendarColorAtIndex(indexPath.row)
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
        self.navigationItem.rightBarButtonItem?.enabled = viewModel?.shouldProcceed ?? false
    }
    
    func didTapSaveBarButtonItem(sender: UIBarButtonItem) {
        viewModel?.save()
        saveCompletionBlock?()
        
        if isModal {
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
