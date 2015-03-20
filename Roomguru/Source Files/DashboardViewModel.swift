//
//  DashboardViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

private struct CellItem {
    
    let title: NSString
    let action: NSString
    let identifier : Identifier
    
    enum Identifier {
        case RevokeEvent, BookRoom
    }
}

class DashboardViewModel: NSObject {
    
    private let items: [CellItem] = [
        CellItem(title: "Revoke event", action: "revokeEvent:", identifier: .RevokeEvent),
        CellItem(title: "Book first available room", action: "bookRoom:", identifier: .BookRoom),
    ]
    
    // MARK: Public Methods
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func configureCell(cell: UITableViewCell, atIndex row: Int) {
        
        if let cell = cell as? TableButtonCell {
            
            let item = items[row]
            
            cell.button.addTarget(self, action: Selector(item.action))
            cell.button.setTitle(item.title)
            
            var color: UIColor?
            switch(item.identifier) {
            case .RevokeEvent:
                color = UIColor.redColor()
            case .BookRoom:
                color = UIColor.blueColor()
            }
            
            cell.button.backgroundColor = color
        }
    }
    
    func reuseIdentifier() -> String {
        return TableButtonCell.reuseIdentifier
    }
    
    func cellClass() -> AnyClass {
        return TableButtonCell.self
    }
    
    // MARK: UIControl Methods
    
    func revokeEvent(sender: UIButton) {
        println("revokeEvent")
    }
    
    func bookRoom(sender: UIButton) {
        
        let allRooms = [Room.Aqua, Room.Cold, Room.Middle]
        
        NetworkManager.sharedInstance.freebusyList(allRooms, success: { (response: JSON?) -> () in
                println(response)
            }, failure: { (error: NSError) -> () in
                println(error)
            })
    }
}
