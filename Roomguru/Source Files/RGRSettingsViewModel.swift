//
//  SettingsViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class RGRSettingsViewModel: NSObject {
    
    private let items : [RGRSettingsItem] = [
        RGRSettingsItem(NSLocalizedString("Sign out", comment: ""), .buttonType, "signOutHandler"),
        RGRSettingsItem(NSLocalizedString("Receive notifications", comment: ""), .switchType, "notificationSwitchHandler:")
    ]
    
    // MARK: Public Methods
    
    func numberOfItems() -> Int {
        return items.count
    }

    func configureCell(cell: UITableViewCell, atIndex row: Int) {
        
        let item = items[row]

        if let theCell = cell as? RGRTableViewSwitchCell {
            theCell.switchControl.addTarget(self, action: Selector(item.action), forControlEvents: .ValueChanged)
            
            switch(index) {
            default: //temporary in default statement. Play with indexes later if more cell will appear
                theCell.switchControl.setOn(RGRSettings.isNotifcationEnabled(), animated: false)
            }
        }

        cell.textLabel?.text = item.title
    }
    
    func identifierForIndex(index: Int) -> String {
        return items[index].signature().identifier
    }
    
    func signatures() -> [String : AnyClass] {
        var dictionary = Dictionary<String, AnyClass>()
        for type in items {
            dictionary[type.signature().identifier] = type.signature().registeredClass
        }
        return dictionary
    }
    
    func performActionForIndex(index: Int) {
         items[index].performActionWithTarget(self)
    }
    
    func selectable(index: Int) -> Bool {
        return items[index].selectable()
    }
    
    // MARK: Settings Item Action Handlers
    
    func signOutHandler() {
        (UIApplication.sharedApplication().delegate as AppDelegate).signOut()
    }
    
    func notificationSwitchHandler(sender: UISwitch) {
        RGRSettings.reverseNotificationEnabled()
    }
    
}
