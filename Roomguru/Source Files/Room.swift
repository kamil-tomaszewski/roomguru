//
//  Room.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 19/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct NetguruRoom {
    
    let Aqua    = "netguru.pl_2d36343438343933352d363234@resource.calendar.google.com"
    let Middle  = "netguru.pl_2d36343339373131332d333131@resource.calendar.google.com"
    let Cold    = "netguru.pl_2d31333939333835343935@resource.calendar.google.com"
    let Test    = "netguru.pl_oahrqgdhpvo9a49qk3q921am54@group.calendar.google.com"
    let Other   = ""
    
    subscript(index: Int) -> String {
        get {
            switch index {
            case 1: return self.Aqua
            case 2: return self.Middle
            case 3: return self.Cold
            case 4: return self.Test
            default: return self.Other
            }
        }
    }
    
    let names = [
        NSLocalizedString("All", comment: ""),
        NSLocalizedString("Aqua", comment: ""),
        NSLocalizedString("Middle", comment: ""),
        NSLocalizedString("Cold", comment: "")
    ];
}

let Room = NetguruRoom()
