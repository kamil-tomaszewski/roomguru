//
//  Constants.swift
//  Roomguru
//
//  Created by Bartosz Kopiński on 26/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct Constants {
    struct HockeyApp {
        static let ClientID = "e0b60ed8278c9ee0aed4007fffd86458"
    }

    struct GooglePlus {
        static let Scope = ["https://www.googleapis.com/auth/calendar"]
        static let ServerURL = "https://www.googleapis.com/calendar/v3"

        #if ENV_STAGING
            static let ClientID = "860224755984-etmsurv60hiq7dds925q79tdp3a62b1t.apps.googleusercontent.com"
        #else
            static let ClientID = "860224755984-fiktpv8httrrbgdefop68d554kvepshp.apps.googleusercontent.com"
        #endif
    }
}