//
//  UIButtonExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 17/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UIButton {
    
    func setTitle(title: String?) {
        setTitle(title, forState: .Normal)
    }
    
    func addTarget(target: AnyObject?, action: Selector) {
        addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
    
    func removeTarget(target: AnyObject?, action: Selector) {
        removeTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
}
