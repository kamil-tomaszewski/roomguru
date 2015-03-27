//
//  UITableViewExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UITableView {
    
    func deselectRowIfSelectedAnimated(animated: Bool) {
        if let indexPath = self.indexPathForSelectedRow() {
            self.deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
}

