//
//  AppDelegate.swift
//  Project
//
//  Copyright (c) 2015 Netguru Sp. z o.o.All rights reserved.
//

import UIKit
import HockeySDK
import PKHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private(set) var authenticator: GPPAuthenticator!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        application.statusBarStyle = .LightContent
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = TabBarController()
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        
        setupVendors()
        presentAuthenticationScreenAndBeginAuthentication()
        
        return true
    }
    
    func signOut() {
        authenticator.signOut()
        CalendarPersistenceStore.sharedStore.clear()
        UserPersistenceStore.sharedStore.clear()
    }
    
    func presentLoginViewController(animated: Bool, completion: VoidBlock? = nil) {
        let tabBarViewController = window!.rootViewController as! TabBarController
        tabBarViewController.presentLoginViewController(animated, completion: completion)
    }
    
    func popNavigationStack() {
        let tabBarViewController = window!.rootViewController as! TabBarController
        tabBarViewController.selectedIndex = 0
        tabBarViewController.popNavigationStack()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        if !authenticator.isAuthenticating {
            showGoogleSignInButtonInLoginViewController(true)
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        showGoogleSignInButtonInLoginViewController(false)
        return authenticator.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func presentAuthenticationScreenAndBeginAuthentication() {
        
        let tabBarController = window!.rootViewController as! TabBarController
        var launchViewController: UIViewController? = NavigationController(rootViewController: LaunchViewController())
        window!.addSubview(launchViewController!.view)
        
        
        authenticator = GPPAuthenticator() { (authenticated, auth, error) in

            if let auth = auth {
                UserPersistenceStore.sharedStore.registerUserWithEmail(auth.userEmail)
                NetworkManager.sharedInstance.enableTokenStore(auth: auth)
            }
            
            if authenticated {
                
                let didUserSelectCalendars = !CalendarPersistenceStore.sharedStore.calendars.isEmpty
                if didUserSelectCalendars {
                    tabBarController.refreshFirstTab()
                    fade(.Out, launchViewController?.view) {
                        launchViewController?.view.removeFromSuperview()
                        launchViewController = nil
                    }
                } else {
                    tabBarController.presentCalendarPickerViewController(false) {
                        fade(.Out, launchViewController?.view) {
                            launchViewController?.view.removeFromSuperview()
                            launchViewController = nil
                        }
                    }
                }
            } else {
                tabBarController.presentLoginViewController(false, error: error) {
                    fade(.Out, launchViewController?.view) {
                        launchViewController?.view.removeFromSuperview()
                        launchViewController = nil
                    }
                }
            }
        }
        
        authenticator.startAuthentication()
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
    
    func setupVendors() {
        #if !ENV_DEVELOPMENT
            BITHockeyManager.sharedHockeyManager().configureWithIdentifier(AppConfiguration.HockeyApp.ClientID);
            BITHockeyManager.sharedHockeyManager().startManager();
            BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation();
        #endif
        
        NetworkManager.sharedInstance.serverURL = AppConfiguration.GooglePlus.ServerURL
        NetworkManager.sharedInstance.clientID = AppConfiguration.GooglePlus.ClientID
        
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.dimsBackground = false
    }
}
