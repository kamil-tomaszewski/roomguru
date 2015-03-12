//
//  AppDelegate.swift
//  Project
//
//  Copyright (c) 2015 Netguru Sp. z o.o.All rights reserved.
//

import UIKit
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupVendors()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = UINavigationController(rootViewController: RGRLoginViewController())
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        
        return true
    }
    
    //MARK: Google oAuth Methods
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    //MARK: Private Methods
    
    func setupVendors() {
        
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier("e0b60ed8278c9ee0aed4007fffd86458");
        BITHockeyManager.sharedHockeyManager().startManager();
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation();
        
        RGRNetworkManager.sharedInstance.setServerURL("https://www.googleapis.com/calendar/v3")
        
        let sharedSignIn = GPPSignIn.sharedInstance();
        sharedSignIn.clientID = "860224755984-fiktpv8httrrbgdefop68d554kvepshp.apps.googleusercontent.com"
        sharedSignIn.scopes = [kGTLAuthScopePlusLogin, "https://www.googleapis.com/auth/calendar"]
        sharedSignIn.shouldFetchGoogleUserID = true
    }
}

