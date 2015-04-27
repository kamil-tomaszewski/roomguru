//
//  SettingsStore.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

private let notificationKey = "NotificationKey"

class SettingsStore {
    
    func enableNotification(enable: Bool) {
        Defaults[notificationKey] = enable
    }
    
    func isNotificationEnabled() -> Bool {
        return Defaults[notificationKey].bool ?? false
    }
}
