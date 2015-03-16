//
//  RGRSettingsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class RGRSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var aView: RGRSettingsView?
    private let viewModel = SettingsViewModel()
    
    // MARK: View life cycle

    override func loadView() {
        var view = RGRSettingsView(frame: UIScreen.mainScreen().applicationFrame)
        view.autoresizingMask = .FlexibleRightMargin | .FlexibleLeftMargin | .FlexibleBottomMargin | .FlexibleTopMargin
        
        self.view = view
        aView = view;
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
        viewModel.configureCellForIndex(cell: cell, index: indexPath.row)
        
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
