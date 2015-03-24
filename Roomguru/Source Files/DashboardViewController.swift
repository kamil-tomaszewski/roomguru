//
//  DashboardViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var aView: DashboardView?
    private let viewModel = DashboardViewModel()
    
    // MARK: View life cycle

    override func loadView() {
        aView = loadViewWithClass(DashboardView.self) as? DashboardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.items = [
            CellItem(title: "Revoke event", target:viewModel, action: "revokeEvent", identifier: .RevokeEvent),
            CellItem(title: "Book first available room", target:viewModel, action: "bookRoom", identifier: .BookRoom)
        ]
        
        aView?.tableView.delegate = self;
        aView?.tableView.dataSource = self;
        aView?.tableView.registerClass(TableButtonCell.self, forCellReuseIdentifier: TableButtonCell.reuseIdentifier)
        
        centralizeTableView()
    }
    
    // MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableButtonCell.reuseIdentifier) as UITableViewCell
        
        if let _cell = cell as? TableButtonCell {
            
            let item = viewModel.items[indexPath.row]
            
            _cell.button.addTarget(item.target, action: Selector(item.action))
            _cell.button.setTitle(item.title)
            
            var color: UIColor?
            switch(item.identifier) {
            case .RevokeEvent:
                color = UIColor.redColor()
            case .BookRoom:
                color = UIColor.blueColor()
            }
            
            _cell.button.backgroundColor = color
        }
        
        return cell;
    }
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: Private Methods
    
    private func centralizeTableView() {
        let topInset = max(0, (contentViewHeight() - requiredHeight()) / 2)
        aView?.tableView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    }
    
    private func requiredHeight() -> CGFloat {
        
        if let rowHeight = aView?.tableView.rowHeight {
            return CGFloat(viewModel.numberOfItems()) * rowHeight
        }
        return 0
    }
    
    private func contentViewHeight() -> CGFloat {
        
        let topInset = (self.navigationController != nil) ? self.navigationController!.navigationBar.frame.size.height : 0
        let bottomInset = (self.tabBarController != nil) ? self.tabBarController!.tabBar.frame.size.height : 0

        return (aView != nil) ? aView!.bounds.height - topInset - bottomInset : 0
    }
}
