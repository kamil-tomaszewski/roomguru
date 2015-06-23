//
//  UIBarButtonItemExtensions.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 21/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    class func loaderItemWithTintColor(tintColor: UIColor, style: UIActivityIndicatorViewStyle = .White) -> UIBarButtonItem {
        let loader = UIActivityIndicatorView(activityIndicatorStyle: style)
        loader.color = tintColor
        loader.startAnimating()
        return UIBarButtonItem(customView: loader)
    }
}
