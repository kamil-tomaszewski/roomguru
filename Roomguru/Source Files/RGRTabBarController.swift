//
//  RGRTabBarController.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 12.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class RGRTabBarController: UITabBarController {
    
    override init() {
        super.init()
        
        self.viewControllers = [RGRDashboardViewController(), RGRSettingsViewController()]
        
        func controllerForIndex(index: Int) -> UITabBarItem {
            return self.tabBar.items![index] as UITabBarItem
        }
        
        controllerForIndex(0).title = NSLocalizedString("Dashboard", comment: "")
        controllerForIndex(1).title = NSLocalizedString("Settings", comment: "")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
