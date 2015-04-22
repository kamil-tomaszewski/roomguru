//
//  PickerViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 22/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol TableViewConfigurable {
    func registerCellsInTableView(tableView: UITableView)
    func configureCell(cell: UITableViewCell, forItem item: PickerItem)
    func reuseIdenfitierForItem(item: PickerItem) -> String
}

protocol PickerViewControllerDelegate {
    func pickerViewController(controller: PickerViewController, didChooseItem item: PickerItem)
}

class PickerViewController: UIViewController {
    
    var delegate: TableViewConfigurable?
    
    private var aView = UIBaseTableView()
    private var viewModel = ListViewModel<PickerItem>([PickerItem]())
    private var onSelectionBlock: (item: PickerItem) -> Void = { item in }
    
    init(viewModel: ListViewModel<PickerItem>, onSelection: (item: PickerItem) -> Void) {
        self.viewModel = viewModel
        self.onSelectionBlock = onSelection
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        aView = loadViewWithClass(UIBaseTableView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableView(aView.tableView)
    }
}

// MARK: UITableViewDataSource

extension PickerViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.sectionsCount()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel[section]?.count ?? viewModel.itemsCount()
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let item: PickerItem = viewModel[indexPath.row],
            identifier = delegate?.reuseIdenfitierForItem(item),
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell {
                
                delegate?.configureCell(cell, forItem: item)
                return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate

extension PickerViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowIfSelectedAnimated(true)
        
        if let item: PickerItem = viewModel[indexPath.row] {
            viewModel.itemize { $1.selected = false }
            item.selected = true
            onSelectionBlock(item: item)
            tableView.reloadData()
        }
    }
}


// MARK: Private

private extension PickerViewController {
    
    func bindTableView(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        delegate?.registerCellsInTableView(tableView)
    }
}
