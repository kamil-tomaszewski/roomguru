//
//  LaunchViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    weak var aView: LaunchView?
    
    // MARK: Lifecycle
    
    override func loadView() {
        aView = loadViewWithClass(LaunchView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        aView?.avatarView.imageView.image = UserPersistenceStore.sharedStore.userImage()
    }
}
