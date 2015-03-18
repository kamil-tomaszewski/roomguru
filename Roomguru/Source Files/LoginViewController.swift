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
        aView = loadViewWithClass(LoginView.self) as? LoginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "googlePlusAuthorizationFinished", name: RoomguruGooglePlusAuthenticationDidFinishNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Google+ notification
    
    func googlePlusAuthorizationFinished() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
