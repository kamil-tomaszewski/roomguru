//
//  Constants.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 08/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/* NOTICE
 * Rename this struct to Constants. Also remember to rename file in project tree.
 * If you want store this keys on your own repository,
 * remove `Constants.swift` from .gitignore.
 */

struct Constants_Sample {
    
    struct HockeyApp {
        static let ClientID = ""
    }
    
    struct GooglePlus {
        static let Scope = ["https://www.googleapis.com/auth/calendar", kGTLAuthScopePlusUserinfoEmail]
        static let ServerURL = "https://www.googleapis.com/calendar/v3"
        static let RefreshTokenURL = "https://www.googleapis.com/oauth2/v3/token"
        
        static let ClientID = ""
    }
    
    struct Google {
        static let ResourceCalendarsURL = NSURL(string: "https://support.google.com/a/answer/1686462?hl=en")
    }
}
