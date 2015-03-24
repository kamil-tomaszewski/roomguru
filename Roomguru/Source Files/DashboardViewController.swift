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
        
        aView?.tableView.delegate = self;
        aView?.tableView.dataSource = self;
        aView?.tableView.registerClass(viewModel.cellClass(), forCellReuseIdentifier: viewModel.reuseIdentifier())
        
        centralizeTableView()
    }
    
    // MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(viewModel.reuseIdentifier()) as UITableViewCell
        viewModel.configureCell(cell, inViewController: self, atIndex: indexPath.row)
        
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
    
    // MARK: Actions
    
    func bookRoom() {
        let bookingManager = BookingManager()
        
        bookingManager.bookTheClosestAvailableRoom({ (response) -> () in
            
        }, failure: { (error) -> () in
            println(error)
        })
    }
}
