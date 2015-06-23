//
//  SwitchItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 17/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SwitchItem: GroupItem {
    
    var on = false
    var onValueChanged: BoolBlock?
    
    init(title: String) {
        super.init(title: title, category: .Boolean)
    }
    
    func bindSwitchControl(switchControl: UISwitch) {
        switchControl.addTarget(self, action: "didChangeSwitchState:forEvents:", forControlEvents: .ValueChanged)
    }
    
    func unbindSwitchControl(switchControl: UISwitch) {
        switchControl.removeTarget(self, action: "didChangeSwitchState:forEvents:", forControlEvents: .ValueChanged)
    }
    
    func didChangeSwitchState(sender: UISwitch, forEvents events: UIControlEvents) {
        on = sender.on
        onValueChanged?(bool: sender.on)
    }
}
