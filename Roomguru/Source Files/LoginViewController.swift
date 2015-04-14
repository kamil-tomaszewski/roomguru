//
//  LoginViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 10.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController  {

    weak var aView: LoginView?

    // MARK: Lifecycle

    override func loadView() {
        aView = loadViewWithClass(LoginView.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Login", comment: "")
        aView?.avatarImageView.image = UserPersistenceStore.sharedStore.userImage()
    }
    
    // MARK: Public
    
    func pushCalendarPickerViewController() {
        aView?.avatarImageView.image = UserPersistenceStore.sharedStore.userImage()
        
        let calendarPickerViewController = CalendarPickerViewController()
        calendarPickerViewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(calendarPickerViewController, animated: true)
    }
}
