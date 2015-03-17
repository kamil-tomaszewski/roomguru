//
//  Settings.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

private let notificationKey = "NotificationKey"

class Settings {
    
    class func enableNotifcation(enable: Bool) {
        Defaults[notificationKey] = enable
    }
    
    class func isNotifcationEnabled() -> Bool {
        if let enabled = Defaults[notificationKey].bool {
            return enabled
        }
        return false
    }
    
    class func reverseNotificationEnabled() {
        Settings.enableNotifcation(!Settings.isNotifcationEnabled() )
    }
}
