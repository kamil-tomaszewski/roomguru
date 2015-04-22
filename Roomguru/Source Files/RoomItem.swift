//
//  RoomItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 22/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class RoomItem: PickerItem {
    
    var name: String { get { return room.name } }
    var id: String { get { return room.id } }
    
    private let room: (name: String, id: String)
    
    init(room: (name: String, id: String)) {
        self.room = room
    }
}
