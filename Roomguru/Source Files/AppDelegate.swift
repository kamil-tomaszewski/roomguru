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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let authenticator = GPPAuthenticator()

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
    
    // MARK: Google oAuth Methods
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

// MARK: Private

private extension AppDelegate {
    
    func authenticate() {
        
        let tabBarController = window!.rootViewController as! TabBarController
        var launchViewController: UIViewController? = NavigationController(rootViewController: LaunchViewController())
        window!.addSubview(launchViewController!.view)
        
        authenticator.authenticateWithCompletion { (authenticated, auth, error) in

            if let _auth = auth {
                UserPersistenceStore.sharedStore.registerUserWithEmail(_auth.userEmail)
                NetworkManager.sharedInstance.setAuthentication(_auth)
            }
            
            if authenticated {
                
                let didUserSelectCalendars = CalendarPersistenceStore.sharedStore.calendars.count > 0
                if didUserSelectCalendars {
                    fadeOut(launchViewController!.view) {
                        launchViewController = nil
                    }
                } else {
                    tabBarController.presentCalendarPickerViewController(false) {
                        fadeOut(launchViewController!.view) {
                            launchViewController = nil
                        }
                    }
                }
            } else {
                tabBarController.presentLoginViewController(false) {
                    fadeOut(launchViewController!.view) {
                        launchViewController = nil
                    }
                }
            }
        }
    }
    
    func setupVendors() {
        #if !ENV_DEVELOPMENT
            BITHockeyManager.sharedHockeyManager().configureWithIdentifier(Constants.HockeyApp.ClientID);
            BITHockeyManager.sharedHockeyManager().startManager();
            BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation();
        #endif
        
        NetworkManager.sharedInstance.setServerURL(Constants.GooglePlus.ServerURL)
    }
}

