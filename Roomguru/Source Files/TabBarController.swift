//
//  TabBarController.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 12.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class TabBarController: UITabBarController {
    
    // MARK: Lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupEmbeddedViewControllers()
        
        self.tabBar.tintColor = UIColor.ngOrangeColor()
        self.tabBar.barTintColor = UIColor.ngBarTranslucentGrayColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if (!GPPSignIn.isUserSignedIn()) {
            if (GPPSignIn.hasSilentAuthenticationSucceeded()) {
                println("user is signed in")
            } else {
                presentLoginViewController(nil)
            }
        }
    }
    
    // MARK: Public Methods
    
    func popNavigationStack() {
        
        if let controllers = self.viewControllers as? [UINavigationController] {
            for navigationController in controllers {
                navigationController.popToRootViewControllerAnimated(false)
            }
        }
    }
    
    func presentLoginViewController(completion: (() -> Void)?) {
        self.presentViewController(LoginViewController(), animated: true, completion: completion);
    }
    
    // MARK: Private Methods
    
    private func setupEmbeddedViewControllers() {
        
        let pageControllerSource = EventsPageViewControllerSource()
        let pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        
        pageController.dataSource = pageControllerSource
        pageController.delegate = pageControllerSource
        
        pageController.setViewControllers([EventsViewController(date: NSDate())], direction: .Forward, animated: true, completion: nil)
        
        self.viewControllers = [
            NavigationController(rootViewController: DashboardViewController()),
            NavigationController(rootViewController: pageController),
            NavigationController(rootViewController: SettingsViewController())
        ]
        
        func setTitleForControllerAtIndex(index: Int, title: String) {
            let tabBarItem = self.tabBar.items![index] as! UITabBarItem
            tabBarItem.title = title
            
            let navigation = self.viewControllers![index] as! UINavigationController
            let viewController = navigation.viewControllers.first as! UIViewController
            viewController.title = title
        }
        
        setTitleForControllerAtIndex(0, NSLocalizedString("Dashboard", comment: ""))
        setTitleForControllerAtIndex(1, NSLocalizedString("Events", comment: ""))
        setTitleForControllerAtIndex(2, NSLocalizedString("Settings", comment: ""))
    }
}
