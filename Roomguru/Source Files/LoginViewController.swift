//
//  LoginViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 10.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, GPPSignInDelegate  {

    weak var aView: LoginView?

    //MARK: Lifecycle

    override func loadView() {
        aView = loadViewWithClass(LoginView.self) as? LoginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let sharedSignIn = GPPSignIn.sharedInstance()
        sharedSignIn.delegate = self
    }

    //MARK: GPPSignInDelegate Methods

    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if (error != nil) {
            println(error)
        } else {
            NetworkManager.sharedInstance.setAuthentication(auth)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func didDisconnectWithError(error: NSError!) {
        println(error)
    }
}
