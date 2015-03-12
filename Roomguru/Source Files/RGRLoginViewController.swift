//
//  LoginViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 10.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class RGRLoginViewController: UIViewController, GPPSignInDelegate  {
    
    weak var aView: RGRLoginView?
    
    //MARK: Lifecycle
    
    override func loadView() {
        var view = RGRLoginView(frame: UIScreen.mainScreen().applicationFrame)
        view.autoresizingMask = .FlexibleRightMargin | .FlexibleLeftMargin | .FlexibleBottomMargin | .FlexibleTopMargin
        
        self.view = view
        aView = view;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sharedSignIn = GPPSignIn.sharedInstance()
        sharedSignIn.delegate = self
        sharedSignIn.shouldFetchGoogleUserID = true
        sharedSignIn.scopes = [kGTLAuthScopePlusLogin, "https://www.googleapis.com/auth/calendar"]
    }
    
    //MARK: GPPSignInDelegate Methods
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if (error != nil) {
            println(error)
        } else {
            let rgrTabBarController = RGRTabBarController()
            self.navigationController?.pushViewController(rgrTabBarController, animated: true)
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
        println(error)
    }
}
