//
//  UINavigationControllerExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UINavigationController {
    
    func titleViewFrame() -> CGRect {
        return CGRectMake(0, 0, CGRectGetWidth(navigationBar.frame), CGRectGetHeight(navigationBar.frame))
    }
}
