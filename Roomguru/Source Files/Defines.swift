//
//  Defines.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 12/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation


// MARK: Types
// MARK: - Closures

typealias VoidBlock = () -> ()
typealias ResponseBlock = (response: JSON?) -> ()
typealias ListResponseBlock = (response: [AnyObject]?) -> ()
typealias ErrorBlock = (error: NSError) -> ()

// MARK: - Data types

typealias QueryParameters = [String: AnyObject]


// MARK: Notifications

let RoomguruGooglePlusAuthenticationDidFinishNotification = "RoomguruGooglePlusAuthenticationDidFinishNotification"

// MARK: Reuse identifiers

let UITableViewCellReuseIdentifier = "RegularTableViewCellReuseIdentifier"
