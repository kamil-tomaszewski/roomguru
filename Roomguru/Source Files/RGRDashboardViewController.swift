//
//  RGRDashboardViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class RGRDashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var aView: RGRDashboardView?
    private let viewModel = RGRDashboardViewModel()

    // MARK: View life cycle

    override func loadView() {
        aView = loadViewWithClass(RGRDashboardView.self) as? RGRDashboardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aView?.tableView.delegate = self;
        aView?.tableView.dataSource = self;

    }
    
    //MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Temporary
        let cell = UITableViewCell()
        return cell
    }
    
    //MARK: UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

}
