//
//  SettingsStore.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

private let NotificationKey = "NotificationKey"

class SettingsStore {
    
    func enableNotification(enable: Bool) {
        Defaults[NotificationKey] = enable
    }
    
    func isNotificationEnabled() -> Bool {
        return Defaults[NotificationKey].bool ?? false
    }
}
