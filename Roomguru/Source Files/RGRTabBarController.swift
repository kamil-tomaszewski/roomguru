//
//  RGRTabBarController.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 12.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class RGRTabBarController: UITabBarController {
    
    // MARK: Lifecycle
    
    override init() {
        super.init()
        setupEmbeddedViewControllers()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if (!RGRNetworkManager.isUserSignedIn()) {

            if (RGRNetworkManager.hasSilentAuthenticationSucceeded()) {
                println("user is signed in")
            } else {
                self.presentViewController(RGRLoginViewController(), animated: true, completion: nil);
            }
        }
    }
    
    // MARK: Private Methods
    
    private func setupEmbeddedViewControllers() {
        
        self.viewControllers = [
            UINavigationController(rootViewController: RGRDashboardViewController()),
            UINavigationController(rootViewController: RGRSettingsViewController()),
        ]
        
        func setTitleForControllerAtIndex(index: Int, title: String) {
            let tabBarItem = self.tabBar.items![index] as UITabBarItem
            tabBarItem.title = title
            
            let navigation = self.viewControllers![index] as UINavigationController
            let viewController = navigation.viewControllers.first as UIViewController
            viewController.title = title
        }
        
        setTitleForControllerAtIndex(0, NSLocalizedString("Dashboard", comment: ""))
        setTitleForControllerAtIndex(1, NSLocalizedString("Settings", comment: ""))
    }
}
