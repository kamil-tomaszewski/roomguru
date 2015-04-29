//
//  UITableViewExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

extension UITableView {
    
    func deselectRowIfSelectedAnimated(animated: Bool) {
        if let indexPath = self.indexPathForSelectedRow() {
            deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
    
    func reloadAndDeselectRowAtIndexPath(indexPath: NSIndexPath, animated: Bool = true)  {
        reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        deselectRowAtIndexPath(indexPath, animated: animated)
    }
    
    func hideSeparatorForEmptyCells() {
        tableFooterView = UIView(frame: CGRectZero)
    }
    
    func registerClass<T where T: UITableViewCell, T: Reusable>(aClass: T.Type) {
        registerClass(aClass, forCellReuseIdentifier: T.reuseIdentifier())
    }
    
    func dequeueReusableCell<T where T: UITableViewCell, T: Reusable>(aClass: T.Type) -> T {
        return dequeueReusableCellWithIdentifier(T.reuseIdentifier()) as! T
    }
}
