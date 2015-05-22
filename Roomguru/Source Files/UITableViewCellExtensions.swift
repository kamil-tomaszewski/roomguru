//
//  UITableViewCellExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 22/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UITableViewCell {
    
    func lengthenSeparatorLine() {
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsetsZero
    }
}
