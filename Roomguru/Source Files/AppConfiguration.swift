//
//  AppConfiguration.swift
//  Roomguru
//
//  Created by Bartosz Kopiński on 26/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct AppConfiguration {
    struct HockeyApp {
        static let ClientID = "e0b60ed8278c9ee0aed4007fffd86458"
    }

    struct GooglePlus {
        static let Scope = ["https://www.googleapis.com/auth/calendar", kGTLAuthScopePlusUserinfoEmail]
        static let ServerURL = "https://www.googleapis.com/calendar/v3"
        static let RefreshTokenURL = "https://www.googleapis.com/oauth2/v3/token"

        #if ENV_STAGING
            static let ClientID = "860224755984-etmsurv60hiq7dds925q79tdp3a62b1t.apps.googleusercontent.com"
        #else
            static let ClientID = "860224755984-fiktpv8httrrbgdefop68d554kvepshp.apps.googleusercontent.com"
        #endif
    }
    
//    struct Timeline {
//        static let MinimumEventDuration: NSTimeInterval = 60*15 //15 minutes
//        static let DefaultEventDuration: NSTimeInterval = 60*30 //30 minutes
//        static let TimeStep: NSTimeInterval = 60*30 // 30 minutes
//        
//        // Time range within you can book events.
//        // Below means: first available event will be bookable at 7 AM, and the last one at 5 PM
//        static let BookingRange: (min: NSTimeInterval, max: NSTimeInterval) = (60*60*7, 60*60*17)
//            
//        // Set the days within booking will be possible. 1st - sunday, 7th - saturday
//        static let BookingDays = [2, 3, 4, 5, 6]
//    }
}
