//
//  UIButtonExtension.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 17/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UIButton {
    
    func setTitle(title: String?) {
        self.setTitle(title, forState: .Normal)
    }
    
    func addTarget(target: AnyObject?, action: Selector) {
        self.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
}
