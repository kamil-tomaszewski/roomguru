//
//  SettingsViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class SettingsViewModel: NSObject {
    
    private let items : [SettingsItem] = [
        SettingsItem(title: NSLocalizedString("Sign out", comment: ""), type: .buttonType, action: "signOutHandler"),
        SettingsItem(title: NSLocalizedString("Receive notifications", comment: ""), type: .switchType, action: "notificationSwitchHandler:")
    ]
    
    // MARK: Public Methods
    
    func numberOfItems() -> Int {
        return items.count
    }

    func configureCellForIndex(#cell: UITableViewCell, index: Int) {
        
        let item: SettingsItem = items[index]
        if item.type == .switchType {
            (cell as RGRTableViewSwitchCell).aSwitch.addTarget(self, action: Selector(item.action), forControlEvents: .ValueChanged)
            (cell as RGRTableViewSwitchCell).aSwitch.setOn(Settings.isNotifcationEnabled(), animated: false)
        }

        cell.textLabel?.text = item.title
    }
    
    func identifierForIndex(index: Int) -> String {
        return (items[index] as SettingsItem).signature().identifier
    }
    
    func signatures() -> [String : AnyClass] {
        var dictionary = Dictionary<String, AnyClass>()
        for type: SettingsItem in items {
            dictionary[type.signature().identifier] = type.signature().registeredClass
        }
        return dictionary
    }
    
    func performActionForIndex(index: Int) {
         (items[index] as SettingsItem).performActionWithTarget(self)
    }
    
    func selectable(index: Int) -> Bool {
        return (items[index] as SettingsItem).selectable()
    }
    
    // MARK: Settings Item Action Handlers
    
    func signOutHandler() {
        (UIApplication.sharedApplication().delegate as AppDelegate).signOut()
    }
    
    func notificationSwitchHandler(sender: UISwitch) {
        Settings.reverseNotificationEnabled()
    }
    
}
