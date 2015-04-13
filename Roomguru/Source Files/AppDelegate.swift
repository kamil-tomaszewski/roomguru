//
//  AppDelegate.swift
//  Project
//
//  Copyright (c) 2015 Netguru Sp. z o.o.All rights reserved.
//

import UIKit
import HockeySDK
import Foundation
import Async

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
        
        authenticate()
        
        return true
    }
    
    // MARK: GPPSignInDelegate Methods
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if (error != nil) {
            // NGRTodo: handle error here
            UIAlertView(error: error).show()
        } else {
            UserPersistenceStore.sharedStore.registerUserWithEmail(auth.userEmail)
            NetworkManager.sharedInstance.setAuthentication(auth)
            NSNotificationCenter.defaultCenter().postNotificationName(RoomguruGooglePlusAuthenticationDidFinishNotification, object: nil)
        }
    }

    func didDisconnectWithError(error: NSError!) {
        println(error)
    }
    
    // MARK: Google oAuth Methods
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func signOut() {
        CalendarPersistenceStore.sharedStore.clear()
        UserPersistenceStore.sharedStore.clear()
        GPPSignIn.sharedInstance().signOut()
        
        let tabBarViewController = window!.rootViewController as! TabBarController
        tabBarViewController.presentLoginViewController(true) {
            tabBarViewController.selectedIndex = 0
            tabBarViewController.popNavigationStack()
        }
    }
    
    // MARK: Private Methods
    
    private func authenticate() {
        
        let tabBarController = window!.rootViewController as! TabBarController
        let launchView = LaunchView(frame: window!.bounds);
        launchView.avatarImageView.image = UserPersistenceStore.sharedStore.userImage()
        window!.addSubview(launchView)
        
        AppAuthenticator().authenticateWithCompletion { (success) in
            if !success {
                // make a time to setup UI in case of instant return
                Async.main(after: 0.5) {
                    tabBarController.presentLoginViewController(false) {
                        self.hideLaunchView(launchView);
                    }
                }
            } else {
                Async.main(after: 0.5) {
                    self.hideLaunchView(launchView);
                }
                
            }
        }
    }
    
    private func setupVendors() {
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
        sharedSignIn.shouldFetchGoogleUserEmail = true
        sharedSignIn.shouldFetchGooglePlusUser = true
        sharedSignIn.delegate = self
    }
    
    private func hideLaunchView(view: UIView, animated: Bool = true) {
        let duration: NSTimeInterval = animated ? 1 : 0
        UIView.animateWithDuration(duration, animations: {
            view.alpha = 0
        }, completion: { (finished) -> Void in
            view.removeFromSuperview()
        })
    }
}

