//
//  TabBarController.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 12.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class TabBarController: UITabBarController {
    
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

    // MARK: Public Methods
    
    func popNavigationStack() {
        
        if let controllers = self.viewControllers as? [UINavigationController] {
            for navigationController in controllers {
                navigationController.popToRootViewControllerAnimated(false)
            }
        }
    }
    
    func presentLoginViewController(animated: Bool, error: NSError? = nil, completion: VoidBlock? = nil) {

        if let login = controllersOfTypeInNavigationStack(LoginViewController.self)?.first, error = error {
            login.showError(error)
        } else {
            presentControllerOfType(LoginViewController.self, animated: animated) { loginViewController in
            
                if let error = error {
                    loginViewController.showError(error)
                }
                completion?()
            }
        }
    }
    
    func presentCalendarPickerViewController(animated: Bool, completion: VoidBlock? = nil) {
        
        if let login = controllersOfTypeInNavigationStack(LoginViewController.self)?.first {
            login.pushCalendarPickerViewController() {
                self.refreshFirstTab()
            }
        } else {
            presentControllerOfType(CalendarPickerViewController.self, animated: animated) { calendarPickerViewController in
                calendarPickerViewController.saveCompletionBlock = {
                    self.refreshFirstTab()
                }
                completion?()
            }
        }
    }
    
    func refreshFirstTab() {
        
        let controller = viewControllers?.map { ($0 as! NavigationController).viewControllers.first }.filter { $0 is MyEventsViewController }.map { $0 as! MyEventsViewController }.first
        if let controller = controller {

            controller.updateSelectedCalendar()
            controller.updateControllerState()
            controller.reloadEventList()
        }
    }
}

private extension TabBarController {
    
    func setupEmbeddedViewControllers() {
        
        viewControllers = [
            NavigationController(rootViewController: MyEventsViewController()),
            NavigationController(rootViewController: EventsViewController()),
            NavigationController(rootViewController: SettingsViewController())
        ]
        
        func setTitleForControllerAtIndex(index: Int, title: String) {
            let tabBarItem = self.tabBar.items![index] as! UITabBarItem
            tabBarItem.title = title
            
            let navigation = self.viewControllers![index] as! UINavigationController
            let viewController = navigation.viewControllers.first as! UIViewController
            viewController.title = title
        }
        
        setTitleForControllerAtIndex(0, NSLocalizedString("My Events", comment: ""))
        setTitleForControllerAtIndex(1, NSLocalizedString("Events", comment: ""))
        setTitleForControllerAtIndex(2, NSLocalizedString("Settings", comment: ""))
    }
}
