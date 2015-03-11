//
//  AppDelegate.swift
//  Project
//
//  Copyright (c) 2015 Netguru Sp. z o.o.All rights reserved.
//

import UIKit
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GPPSignInDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Crashlytics.startWithAPIKey("82a73e1e2bebf8b04ec1413ff530a075dbcc798d")
        
        let sharedSignIn = GPPSignIn.sharedInstance();
        sharedSignIn.clientID = "860224755984-fiktpv8httrrbgdefop68d554kvepshp.apps.googleusercontent.com"
        sharedSignIn.delegate = self;
        
        if sharedSignIn.trySilentAuthentication() {
            println("success")
        } else {
            println("failure")
        }
        
        var initialViewController = RGRViewController()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = initialViewController
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if (error != nil) {
            GPPSignIn.sharedInstance().signOut()
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
        println(error)
    }
}

