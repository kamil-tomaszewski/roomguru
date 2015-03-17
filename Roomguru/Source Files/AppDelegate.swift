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
        window!.rootViewController = TabBarController()
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        
        return true
    }
    
    //MARK: Google oAuth Methods
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func signOut() {
        GPPSignIn.sharedInstance().signOut()
        let tabBarViewController = window!.rootViewController as TabBarController
        tabBarViewController.presentLoginViewController { () -> Void in
            tabBarViewController.popNavigationStack()
        }
    }
    
    //MARK: Private Methods
    
    func setupVendors() {
        
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier("e0b60ed8278c9ee0aed4007fffd86458");
        BITHockeyManager.sharedHockeyManager().startManager();
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation();
        
        NetworkManager.sharedInstance.setServerURL("https://www.googleapis.com/calendar/v3")
        
        let sharedSignIn = GPPSignIn.sharedInstance();
        sharedSignIn.clientID = gPlusClientID()
        sharedSignIn.scopes = [kGTLAuthScopePlusLogin, "https://www.googleapis.com/auth/calendar"]
        sharedSignIn.shouldFetchGoogleUserID = true
    }
    
    func gPlusClientID() -> NSString {
        #if ENV_STAGING
            return "860224755984-etmsurv60hiq7dds925q79tdp3a62b1t.apps.googleusercontent.com"
        #else
            return "860224755984-fiktpv8httrrbgdefop68d554kvepshp.apps.googleusercontent.com"
        #endif
    }
}

