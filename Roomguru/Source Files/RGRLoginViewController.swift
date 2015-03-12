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
    }
    
    //MARK: GPPSignInDelegate Methods
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if (error != nil) {
            println(error)
        } else {
            RGRNetworkManager.sharedInstance.setAuthentication(auth)

            let rgrTabBarController = RGRTabBarController()
            self.navigationController?.pushViewController(rgrTabBarController, animated: true)
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
        println(error)
    }
}
