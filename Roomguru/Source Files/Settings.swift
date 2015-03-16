//
//  Settings.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

private let notificationKey = "NotificationKey"

class Settings {
    
    class func enableNotifcation(enable: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(enable, forKey: notificationKey)
    }
    
    class func isNotifcationEnabled() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(notificationKey)
    }
    
    class func reverseNotificationEnabled() {
        var enabled = Settings.isNotifcationEnabled()
        Settings.enableNotifcation(!enabled)
    }
}
