//
//  RoomItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 22/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class RoomItem: PickerItem {
    
    override var title: String { get { return room.name } set {} }
    var id: String { return room.id }
    
    private let room: (name: String, id: String)
    
    init(room: (name: String, id: String)) {
        self.room = room
        super.init()
    }
}
