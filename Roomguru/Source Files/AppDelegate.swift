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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let authenticator = AppAuthenticator()

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
        
        authenticator.authenticateWithCompletion { (action, auth, error) in
            
            if let _auth = auth {
                UserPersistenceStore.sharedStore.registerUserWithEmail(_auth.userEmail)
                NetworkManager.sharedInstance.setAuthentication(_auth)
            }
            
            switch action {
            case .Success:
                    self.hideLaunchView(launchView);
            case .Login:
                tabBarController.presentLoginViewController(false) {
                    self.hideLaunchView(launchView);
                }
            case .ChooseCalendars:
                tabBarController.presentCalendarPickerViewController(false) {
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

