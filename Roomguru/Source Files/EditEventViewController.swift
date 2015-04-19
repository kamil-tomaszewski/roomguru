//
//  EditEventViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation


class EditEventViewController: UIViewController {
    
    weak var aView: GroupedBaseTableView?
    
    init(viewModel: EditEventViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel?.delegate = self
        self.title = self.viewModel?.title
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        aView = loadViewWithClass(GroupedBaseTableView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
        setupTableView()
    }
    
    // MARK: Private
    
    private var viewModel: EditEventViewModel?
}

extension EditEventViewController: ModelUpdateable {
    func dataChangedInItems(items: [GroupItem]) {
        aView?.tableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension EditEventViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel?.sectionsCount() ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?[section]?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let item = viewModel?[indexPath.section]?[indexPath.row] {
            let cell = tableView.cellForItemCategory(item.category)
            
            if let item = item as? TextItem, cell = cell as? TextFieldCell {
                cell.textField.delegate = item
                cell.textField.placeholder = item.placeholder
                cell.textField.text = item.title
                return cell
            } else if let item = item as? SwitchItem, cell = cell as? SwitchCell {
                item.bindSwitchControl(cell.switchControl)
                cell.textLabel?.text = item.title
                return cell
            } else if let item = item as? DateItem, cell = cell as? DateCell {
                cell.textLabel?.text = item.title
                cell.dateLabel.text = item.dateString
                cell.timeLabel.text = item.timeString
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                
                if item.selected {
                    cell.setSelectedLabelsColor()
                } else {
                    cell.setDeselectedLabelsColor()
                }
                
                return cell
            } else if let item = item as? LongTextItem, cell = cell as? TextViewCell {
                cell.textView.attributedText = item.attributedPlaceholder
                cell.textView.delegate = item
                return cell
            } else if let item = item as? DatePickerItem, cell = cell as? DatePickerCell {
                cell.datePicker.setDate(item.date, animated: false)
                item.bindDatePicker(cell.datePicker)
                return cell
            } else if let item = item as? ActionItem, cell = cell as? RightDetailTextCell {
                cell.textLabel?.text = item.title
                cell.detailLabel.text = item.detailDescription
                cell.accessoryType = .DisclosureIndicator
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate

extension EditEventViewController: UITableViewDelegate {
        
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowIfSelectedAnimated(true)

        let row = indexPath.row
        let section = indexPath.section
        
        let item = viewModel?[section]?[row]
        item?.selected = true
        
        if let item = item as? DateItem {
            let nextRow = row + 1
            let nextIndexPath = NSIndexPath(forRow: nextRow, inSection: section)
            
            if let nextItem = viewModel?[section]?[nextRow] as? DatePickerItem {
                item.selected = false
                viewModel?.removeItemAtIndexPath(nextIndexPath)
                tableView.deleteRowsAtIndexPaths([nextIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            } else {
                let pickerItem = DatePickerItem(date: item.date) { date in
                    if let error = item.validate(date) {
                        // NGRTemp:
                        println(error)
                        return error
                    } else {
                        item.date = date
                        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    }
                    return nil
                }
                viewModel?.addItem(pickerItem, atIndexPath: nextIndexPath)
                tableView.insertRowsAtIndexPaths([nextIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
}

// MARK: Actions

extension EditEventViewController {
    
    func saveEvent() {
        view.endEditing(true)
        viewModel?.saveEvent({ (response) -> Void in
            self.dismissSelf(self.viewModel)
        }, failure: { (error) -> Void in
            // NGRTemp:
            println(error)
        })
    }
}

// MARK: Private

private extension EditEventViewController {
    
    // MARK: Configuration
    
    func setupTableView() {
        let tableView = aView?.tableView
        
        tableView?.estimatedRowHeight = 44.0
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.registerClass(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView?.registerClass(SwitchCell.self, forCellReuseIdentifier: SwitchCell.reuseIdentifier)
        tableView?.registerClass(DateCell.self, forCellReuseIdentifier: DateCell.reuseIdentifier)
        tableView?.registerClass(TextViewCell.self, forCellReuseIdentifier: TextViewCell.reuseIdentifier)
        tableView?.registerClass(DatePickerCell.self, forCellReuseIdentifier: DatePickerCell.reuseIdentifier)
        tableView?.registerClass(RightDetailTextCell.self, forCellReuseIdentifier: RightDetailTextCell.reuseIdentifier)
    }
    
    func setupBarButtons() {
        let dismissSelector = Selector("dismissSelf:")
        let saveSelector = Selector("saveEvent")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: saveSelector)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: dismissSelector)
    }
}

extension UITableView {

    func cellForItemCategory(category: GroupItem.Category) -> UITableViewCell? {
        var reuseIdentifier = ""
        
        switch category {
        case .PlainText: reuseIdentifier = TextFieldCell.reuseIdentifier
        case .Boolean: reuseIdentifier = SwitchCell.reuseIdentifier
        case .Date: reuseIdentifier = DateCell.reuseIdentifier
        case .LongText: reuseIdentifier = TextViewCell.reuseIdentifier
        case .Picker: reuseIdentifier = DatePickerCell.reuseIdentifier
        case .Action: reuseIdentifier = RightDetailTextCell.reuseIdentifier
        default: reuseIdentifier = ""
        }
        
        return dequeueReusableCellWithIdentifier(reuseIdentifier) as? UITableViewCell
    }
}

