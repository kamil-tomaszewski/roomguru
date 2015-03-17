//
//  SettingsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var aView: SettingsView?
    private let viewModel = SettingsViewModel()
    
    // MARK: View life cycle

    override func loadView() {
        aView = loadViewWithClass(SettingsView.self) as? SettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aView?.tableView.delegate = self;
        aView?.tableView.dataSource = self;
        
        for (identifier, theClass) in viewModel.signatures() {
            aView?.tableView.registerClass(theClass, forCellReuseIdentifier: identifier)
        }
    }
    
    //MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(viewModel.identifierForIndex(indexPath.row)) as UITableViewCell
        viewModel.configureCell(cell, atIndex: indexPath.row)
        
        return cell;
    }
    
    //MARK: UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        viewModel.performActionForIndex(indexPath.row)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return viewModel.selectable(indexPath.row)
    }
}
