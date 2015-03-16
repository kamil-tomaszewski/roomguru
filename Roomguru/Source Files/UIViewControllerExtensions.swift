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
        } else {
            return nil
        }
    }
    
}
