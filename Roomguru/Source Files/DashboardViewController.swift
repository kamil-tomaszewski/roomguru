//
//  DashboardViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    weak var aView: DashboardView?
    
    private let viewModel = DashboardViewModel(items: [
        CellItem(title: "Revoke event", action: .Revoke),
        CellItem(title: "Book first available room", action: .Book)
    ])
    
    // MARK: View life cycle

    override func loadView() {
        aView = loadViewWithClass(DashboardView.self) as? DashboardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        centralizeTableView()
    }
}

// MARK: Actions

extension DashboardViewController {
 
    func didTapBookRoom(sender: UIButton) {
        BookingManager.findClosestAvailableRoom({ (calendarTime: CalendarTimeFrame) -> Void in
            let query = BookingQuery(calendarTime)
            var confirmationViewController = BookingConfirmationViewController(calendarTime) {

                BookingManager.bookTimeFrame(query, success: {
                    println("booking successful")
                }, failure: { (error: NSError) -> () in
                    let errorMessage: String = error.userInfo?["message"] as String
                    println(errorMessage)
                })
                
            }
            
            let navigationVC = NavigationController(rootViewController: confirmationViewController)
            self.presentViewController(navigationVC, animated: true, completion: nil)
            
        }, failure: { (error) -> () in
            println(error)
        })

    }
    
    func didTapRevokeBookedRoom(sender: UIButton) {
        println(__FUNCTION__)
    }
}


// MARK: UITableViewDataSource Methods

extension DashboardViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableButtonCell.reuseIdentifier) as UITableViewCell
        
        if let _cell = cell as? TableButtonCell {
            
            let item = viewModel[indexPath.row]
            let action = (item.action == .Book) ? Selector("didTapBookRoom:") : Selector("didTapRevokeBookedRoom:")
            
            _cell.button.setTitle(item.title)
            _cell.button.backgroundColor = item.color
            _cell.button.addTarget(self, action: action)

        }
        
        return cell;
    }
}


// MARK: UITableViewDelegate Methods

extension DashboardViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

// MARK: Private Methods

extension DashboardViewController {
    
    private func setupTableView() {
        let tableView = aView?.tableView
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.registerClass(TableButtonCell.self, forCellReuseIdentifier: TableButtonCell.reuseIdentifier)
    }
    
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

