//
//  AppDelegate.swift
//  Project
//
//  Copyright (c) 2015 Netguru Sp. z o.o.All rights reserved.
//

import UIKit
import HockeySDK
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GPPSignInDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupVendors()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = TabBarController()
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        
        application.statusBarStyle = .LightContent
        
        return true
    }
    
    // MARK: GPPSignInDelegate Methods
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        NetworkManager.sharedInstance.setAuthentication(auth)
        NSNotificationCenter.defaultCenter().postNotificationName(RoomguruGooglePlusAuthenticationDidFinishNotification, object: nil)
    }
    
    func didDisconnectWithError(error: NSError!) {
        println(error)
    }
    
    // MARK: Google oAuth Methods
    
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
    
    // MARK: Private Methods
    
    func setupVendors() {
        #if !ENV_DEVELOPMENT
            BITHockeyManager.sharedHockeyManager().configureWithIdentifier(Constants.HockeyApp.ClientID);
            BITHockeyManager.sharedHockeyManager().startManager();
            BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation();
        #endif

        NetworkManager.sharedInstance.setServerURL(Constants.GooglePlus.ServerURL)
        
        let sharedSignIn = GPPSignIn.sharedInstance();
        sharedSignIn.clientID = Constants.GooglePlus.ClientID
        sharedSignIn.scopes = Constants.GooglePlus.Scope
        sharedSignIn.shouldFetchGoogleUserID = true
        sharedSignIn.delegate = self
    }
}

