//
//  GPPProfileProvider.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class GPPProfileProvider {
    
    class func downloadImageURLWithCompletion(completion: (success: Bool, url: String) -> Void) {
        
        let query = GTLQueryPlus.queryForPeopleGetWithUserId("me") as! GTLQueryPlus
        let plusService = GTLServicePlus()
        plusService.retryEnabled = true
        plusService.authorizer = GPPSignIn.sharedInstance().authentication
        
        plusService.executeQuery(query) { (_, person, _) in
            
            if let person = person as? GTLPlusPerson {
                completion(success: true, url: person.image.url)
            } else {
                completion(success: false, url: "")
            }
        }
    }
}
