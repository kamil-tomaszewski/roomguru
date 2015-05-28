//
//  UIViewControllerExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UIViewController {
    
    var isModal: Bool {
        return presentingViewController?.presentedViewController == self
                || (navigationController != nil && navigationController?.presentingViewController?.presentedViewController == navigationController)
                || tabBarController?.presentingViewController is UITabBarController
    }
    
    func loadViewWithClass<T: UIView>(viewType: T.Type) -> T {
        
        let view: T = T(frame: UIScreen.mainScreen().applicationFrame)
        view.autoresizingMask = .FlexibleRightMargin | .FlexibleLeftMargin | .FlexibleBottomMargin | .FlexibleTopMargin
        self.view = view
        return view
    }
    
    func hideBackBarButtonTitle() {
        
        if let controllers = self.navigationController?.viewControllers {
            if controllers.count > 1 {
                let controller = controllers[controllers.count - 2] as! UIViewController
                controller.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
            }
        }
    }
    
    func controllersOfTypeInNavigationStack<T: UIViewController>(controller: T.Type) -> [T]? {
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.viewControllers.filter { $0 is T } as? [T]
        }
        return nil
    }
    
    func presentControllerOfType<T:UIViewController>(controller: T.Type, animated: Bool, completion: ((presentedController: T) -> Void)?) {
        let controller = T()
        let navigationController = NavigationController(rootViewController: controller)
        presentViewController(navigationController, animated: animated) {
            completion?(presentedController: controller)
        }
    }
    
    func addContainerViewController<T: UIViewController>(controller: T) {
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
    }
    
    func removeContainerController<T: UIViewController>(controller: T.Type) {
        
        for containerController in containerControllersOfType(controller) {
            containerController.willMoveToParentViewController(nil)
            containerController.view.removeFromSuperview()
            containerController.removeFromParentViewController()
        }
    }
    
    func containerControllersOfType<T: UIViewController>(type: T.Type) -> [T] {
        return childViewControllers.filter { $0.isKindOfClass(type) } as! [T]
    }
}
