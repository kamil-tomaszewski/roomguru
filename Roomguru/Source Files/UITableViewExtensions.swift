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
    
    func reloadAndDeselectRowAtIndexPath(indexPath: NSIndexPath, animated: Bool = true)  {
        self.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        self.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        self.deselectRowAtIndexPath(indexPath, animated: animated)
    }
    
    func hideSeparatorForEmptyCells() {
        self.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func scrollToTopAnimated(animated: Bool) {
        var y: CGFloat = 0
        if let _y = self.tableHeaderView?.frame.height {
            y = -(_y + CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame))
        }
        self.setContentOffset(CGPointMake(0, y), animated: animated)
    }
}
