//
//  UIViewControllerExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func loadViewWithClass<T where T: UIView>(view: T.Type) -> T {
        
        let _view: T = view(frame: UIScreen.mainScreen().applicationFrame)
        _view.autoresizingMask = .FlexibleRightMargin | .FlexibleLeftMargin | .FlexibleBottomMargin | .FlexibleTopMargin
        self.view = _view
        return _view
    }
    
    func hideBackBarButtonTitle() {
        
        if let _controllers = self.navigationController?.viewControllers {
            if _controllers.count > 1 {
                let controller = _controllers[_controllers.count - 2] as! UIViewController
                controller.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
            }
        }
    }
    
    func isModal() -> Bool {
        return presentingViewController?.presentedViewController == self
            || (navigationController != nil && navigationController?.presentingViewController?.presentedViewController == navigationController)
            || tabBarController?.presentingViewController is UITabBarController
    }
    
    func dismissSelf(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func controllersOfTypeInNavigationStack<T: UIViewController>(controller: T.Type) -> [T]? {
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.viewControllers.filter { $0 is T } as? [T]
        }
        return nil
    }
    
    func presentControllerOfType<T:UIViewController>(controller: T.Type, animated: Bool, completion: VoidBlock?) {
        let navigationController = NavigationController(rootViewController: T())
        presentViewController(navigationController, animated: animated, completion: completion);
    }
    
    func addContainerViewController<T: UIViewController>(controller: T.Type) -> T {
        let controller = controller()
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
        return controller
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
