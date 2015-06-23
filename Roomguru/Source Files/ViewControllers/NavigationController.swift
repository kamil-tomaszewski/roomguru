//
//  NavigationController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class NavigationController: UINavigationController, UINavigationControllerDelegate {
    
    // MARK: Lifecycle
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        navigationBar.tintColor = UIColor.ngOrangeColor()
        navigationBar.barTintColor = UIColor.ngBarTranslucentGrayColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.ngOrangeColor()]
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
