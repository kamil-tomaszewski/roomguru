//
//  RGRDashboardViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class RGRDashboardViewController: UIViewController {

    weak var aView: RGRDashboardView?

    // MARK: View life cycle

    
    override func loadView() {
        aView = loadViewWithClass(RGRDashboardView.self) as? RGRDashboardView
    }

}
