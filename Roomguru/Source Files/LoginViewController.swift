//
//  LoginViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 10.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController  {

    weak var aView: LoginView?

    // MARK: Lifecycle

    override func loadView() {
        aView = loadViewWithClass(LoginView.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Login", comment: "")
        aView?.avatarImageView.image = UserPersistenceStore.sharedStore.userImage()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "googlePlusAuthorizationFinished", name: RoomguruGooglePlusAuthenticationDidFinishNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Google+ notification
    
    func googlePlusAuthorizationFinished() {
    
        let hasSelectedCalendars = CalendarPersistenceStore.sharedStore.calendars.count > 0
        
        //push CalendarPickerViewController only if user doesn't have selected calendars
        if hasSelectedCalendars {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let calendarPickerViewController = CalendarPickerViewController()
            calendarPickerViewController.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(calendarPickerViewController, animated: true)
        }
    }
}
