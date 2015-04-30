//
//  LoginViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 10.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController  {

    private weak var aView: LoginView?

    // MARK: Lifecycle

    override func loadView() {
        aView = loadViewWithClass(LoginView.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Login", comment: "")
        aView?.avatarView.imageView.image = UserPersistenceStore.sharedStore.userImage()
        aView?.signInButton.addTarget(self, action: Selector("didTapSignInButton:"))
    }
    
    // MARK: Public
    
    func pushCalendarPickerViewController() {
        aView?.avatarView.imageView.image = UserPersistenceStore.sharedStore.userImage()
        
        let calendarPickerViewController = CalendarPickerViewController()
        calendarPickerViewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(calendarPickerViewController, animated: true)
    }
    
    func showError(error: NSError) {
        aView?.showSignInButton(true)
        UIAlertView(error: error).show()
    }
    
    func didTapSignInButton(sender: GPPSignInButton) {
        aView?.showSignInButton(false)
    }
}
