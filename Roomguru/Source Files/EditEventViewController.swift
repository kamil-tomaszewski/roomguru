//
//  EditEventViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PKHUD

class EditEventViewController: UIViewController {
    
    private weak var aView: GroupedBaseTableView?
    private var keyboardHandler: KeyboardPresenceHandler!
    private var viewModel: EditEventViewModel<GroupItem>!
    private var didSaveBlock: ((event: Event) -> Void)?
    
    init(calendarEntry: CalendarEntry? = nil, didSaveBlock: ((event: Event) -> Void)?) {
        
        self.didSaveBlock = didSaveBlock
        self.viewModel = EditEventViewModel(calendarEntry: calendarEntry)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.viewModel.presenter = self
        self.title = self.viewModel.title
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        aView = loadViewWithClass(GroupedBaseTableView.self)
        keyboardHandler = KeyboardPresenceHandler(scrollView: aView!.tableView)
        keyboardHandler.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
        setupTableView()
    }
}

extension EditEventViewController: ModelUpdatable {
    
    func didChangeItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        for indexPath in indexPaths {
            if let cell = aView?.tableView.cellForRowAtIndexPath(indexPath) {
                let item = viewModel[indexPath.section][indexPath.row]
                configureEventCell(cell, forItem: item)
            }
        }
    }
        
    func addedItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        aView?.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func removedItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        aView?.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
    }
}

// MARK: Presenter

extension EditEventViewController: Presenter {
    
    func presentViewController(viewController: UIViewController) {
        if let controller = viewController as? PickerViewController {
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: KeyboardPresenceHandlerDelegate

extension EditEventViewController: KeyboardPresenceHandlerDelegate {
    
    func firstReponderForHandler(handler: KeyboardPresenceHandler) -> UIView? {
        return findFirstResponder()
    }
    
    func findFirstResponder() -> UIView? {
        return aView?.findFirstResponder()
    }
}

// MARK: UIScrollViewDelegate

extension EditEventViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        endEditing()
    }
}

// MARK: TableViewConfigurable

extension EditEventViewController: TableViewConfigurable {
    
    func registerCellsInTableView(tableView: UITableView) {
        tableView.registerClass(PickerItemCell.self)
    }
    
    func configureCell(cell: UITableViewCell, forItem item: PickerItem) {
        if let cell = cell as? PickerItemCell {
            cell.textLabel?.text = item.title
            cell.checkmarkLabel.hidden = !item.selected
        }
    }
    
    func reuseIdenfitierForItem(item: PickerItem) -> String {
        return PickerItemCell.reuseIdentifier
    }
}

// MARK: UITableViewDataSource

extension EditEventViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.sectionsCount()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = viewModel[indexPath.section][indexPath.row]
        let cell = tableView.cellForItemCategory(item.category)
        
        configureEventCell(cell, forItem: item)
        
        return cell ?? UITableViewCell()
    }
}

// MARK: UITableViewDelegate

extension EditEventViewController: UITableViewDelegate {
        
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        viewModel.handleSelectionAtIndexPath(indexPath)
        tableView.deselectRowIfSelectedAnimated(true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let item = viewModel[indexPath.section][indexPath.row]
        
        if let item = item as? DatePickerItem, cell = cell as? DatePickerCell {
            item.bindDatePicker(cell.datePicker)
        } else if let item = item as? SwitchItem, cell = cell as? SwitchCell {
            item.bindSwitchControl(cell.switchControl)
        } else if let item = item as? TextItem, cell = cell as? TextFieldCell {
            item.bindTextField(cell.textField)
            
            if item.shouldBeFirstResponder {
                cell.textField.becomeFirstResponder()
            }
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cellIndexPath = tableView.indexPathForCell(cell) ?? indexPath
        let section = cellIndexPath.section
        let row = cellIndexPath.row
        
        if row < viewModel[section].count {
            let item = viewModel[section][row]
            
            if let item = item as? SwitchItem, cell = cell as? SwitchCell {
                item.unbindSwitchControl(cell.switchControl)
            } else if let item = item as? TextItem, cell = cell as? TextFieldCell {
                item.unbindTextField(cell.textField)
            }
        }
    }
}

// MARK: Actions

extension EditEventViewController {
    
    func didTapSaveBarButton(sender: UIBarButtonItem) {
        endEditing()
        
        if let error = viewModel.isModelValid() {
            self.presentViewController(UIAlertController(error: error), animated: true, completion: nil)
            return
        }
        
        PKHUD.sharedHUD.show()
        
        viewModel.saveEvent { (event, error) in
            
            PKHUD.sharedHUD.hide()
            
            if let error = error {
                self.presentViewController(UIAlertController(error: error), animated: true, completion: nil)
                
            } else if let event = event {
                
                self.didSaveBlock?(event: event)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func didTapDismissBarButton(sender: UIBarButtonItem) {
        endEditing()
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: Cell configuration

private extension EditEventViewController {
    
    func configureEventCell(cell: UITableViewCell, forItem item: GroupItem) {
        if let item = item as? TextItem {
            configureTextFieldCell(cell as! TextFieldCell, forItem: item)
        } else if let item = item as? SwitchItem {
            configureSwitchCell(cell as! SwitchCell, forItem: item)
        } else if let item = item as? DateItem {
            configureDateCell(cell as! DateCell, forItem: item)
        } else if let item = item as? LongTextItem {
            configureTextViewCell(cell as! TextViewCell, forItem: item)
        } else if let item = item as? DatePickerItem {
            configureDatePickerCell(cell as! DatePickerCell, forItem: item)
        } else if let item = item as? ResultActionItem {
            configureRightDetailTextCell(cell as! RightDetailTextCell, forItem: item)
        } else if let item = item as? ActionItem {
            configureRightDetailTextCell(cell as! RightDetailTextCell, forItem: item)
        }
    }
    
    func configureTextFieldCell(cell: TextFieldCell, forItem item: TextItem) {
        cell.textField.placeholder = item.placeholder
        cell.validationError = item.validationError
        cell.textField.text = item.text
        cell.selectionStyle = .None
    }
    
    func configureSwitchCell(cell: SwitchCell, forItem item: SwitchItem) {
        cell.textLabel?.text = item.title
        cell.selectionStyle = .None
    }
    
    func configureDateCell(cell: DateCell, forItem item: DateItem) {
        cell.textLabel?.text = item.title
        cell.setDateText(item.dateString, withValidationError: item.validationError)
        cell.shouldBeGreyedOut = !item.active
        cell.setHighlightedLabelColor(item.highlighted && item.active)
    }
    
    func configureTextViewCell(cell: TextViewCell, forItem item: LongTextItem) {
        cell.textView.attributedText = item.attributedText ?? item.attributedPlaceholder
        cell.textView.delegate = item
    }
    
    func configureDatePickerCell(cell: DatePickerCell, forItem item: DatePickerItem) {
        cell.selectionStyle = .None
    }
    
    func configureRightDetailTextCell(cell: RightDetailTextCell, forItem item: ActionItem) {
        cell.textLabel?.text = item.title
        cell.detailLabel.text = item.detailDescription
        cell.accessoryType = .DisclosureIndicator
        cell.isRequired = item is Validatable
    }
    
    func configureRightDetailTextCell(cell: RightDetailTextCell, forItem item: ResultActionItem) {
        configureRightDetailTextCell(cell, forItem: item as ActionItem)
        cell.validationError = item.validationError
    }
    
    func endEditing() {
        viewModel.resignFirstResponderOnItems()
        findFirstResponder()?.resignFirstResponder()
    }
}

// MARK: Private

private extension EditEventViewController {
    
    // MARK: Configuration
    
    func setupTableView() {
        let tableView = aView!.tableView
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(TextFieldCell.self)
        tableView.registerClass(SwitchCell.self)
        tableView.registerClass(DateCell.self)
        tableView.registerClass(TextViewCell.self)
        tableView.registerClass(DatePickerCell.self)
        tableView.registerClass(RightDetailTextCell.self)
    }
    
    func setupBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: Selector("didTapSaveBarButton:"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("didTapDismissBarButton:"))
    }
}

private extension UITableView {

    func cellForItemCategory(category: GroupItem.Category) -> UITableViewCell {
        
        switch category {
        case .PlainText: return dequeueReusableCell(TextFieldCell.self)
        case .Boolean: return dequeueReusableCell(SwitchCell.self)
        case .Date: return dequeueReusableCell(DateCell.self)
        case .LongText: return dequeueReusableCell(TextViewCell.self)
        case .Picker: return dequeueReusableCell(DatePickerCell.self)
        case .Action: return dequeueReusableCell(RightDetailTextCell.self)
        }
    }
}
