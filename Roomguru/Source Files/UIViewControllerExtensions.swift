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
    
    func dismissSelf(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
