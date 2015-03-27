//
//  UIViewControllerExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UIViewController {
   
    func loadViewWithClass(aClass: AnyClass) -> AnyObject? {
        
        if !aClass.isSubclassOfClass(UIView) {
            return nil
        }
        
        if let view = aClass as? UIView.Type {
            let retval = view(frame: UIScreen.mainScreen().applicationFrame)
            retval.autoresizingMask = .FlexibleRightMargin | .FlexibleLeftMargin | .FlexibleBottomMargin | .FlexibleTopMargin
            self.view = retval
            return retval
        }
        
        return nil
    }
    
    func hideBackBarButtonTitle() {
        
        let controllers = self.navigationController?.viewControllers
        
        if let _controllers = controllers {
            if _controllers.count > 1 {
                let controller = _controllers[_controllers.count - 2] as UIViewController
                controller.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
            }
        }
    }
}
