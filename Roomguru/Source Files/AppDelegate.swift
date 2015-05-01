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
        authenticator.signOut()
        CalendarPersistenceStore.sharedStore.clear()
        UserPersistenceStore.sharedStore.clear()
        
        let tabBarViewController = window!.rootViewController as! TabBarController
        tabBarViewController.presentLoginViewController(true) {
            tabBarViewController.selectedIndex = 0
            tabBarViewController.popNavigationStack()
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        if !authenticator.isAuthenticating {
            showGoogleSignInButtonInLoginViewController(true)
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        showGoogleSignInButtonInLoginViewController(false)
        return authenticator.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

// MARK: Private

private extension AppDelegate {
    
    func showGoogleSignInButtonInLoginViewController(show: Bool) {
        
        let tabBarViewController = window!.rootViewController as! TabBarController
        if let loginView = tabBarViewController.controllersOfTypeInNavigationStack(LoginViewController.self)?.first?.view as? LoginView {
            loginView.showSignInButton(show)
        }
    }
    
    func authenticate() {
        
        let tabBarController = window!.rootViewController as! TabBarController
        var launchViewController: UIViewController? = NavigationController(rootViewController: LaunchViewController())
        window!.addSubview(launchViewController!.view)
        
        authenticator.authenticateWithCompletion { (authenticated, auth, error) in

            if let auth = auth {
                UserPersistenceStore.sharedStore.registerUserWithEmail(auth.userEmail)
                NetworkManager.sharedInstance.setAuthentication(auth)
            }
            
            if authenticated {
                
                let didUserSelectCalendars = CalendarPersistenceStore.sharedStore.calendars.count > 0
                if didUserSelectCalendars {
                    fade(.Out, launchViewController?.view) {
                        launchViewController = nil
                    }
                } else {
                    tabBarController.presentCalendarPickerViewController(false) {
                        fade(.Out, launchViewController?.view) {
                            launchViewController = nil
                        }
                    }
                }
            } else {
                tabBarController.presentLoginViewController(false, error: error) {
                    fade(.Out, launchViewController?.view) {
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
