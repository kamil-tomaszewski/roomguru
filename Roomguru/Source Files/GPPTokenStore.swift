//
//  GPPTokenStore.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 31/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import DateKit

/* NOTICE:
 * This class is workaround for g+ issue with refreshing token.
 * Raw request is used.
 * Please use accessToken from this class (not GTMOAuth2Authentication.accessToken).
 */

class GPPTokenStore {
    
    private var token: GTMOAuth2Authentication { return GPPSignIn.sharedInstance().authentication }
    
    private var tokenExpirationDate: NSDate
    private var accessToken: String
    
    init() {
        let token = GPPSignIn.sharedInstance().authentication

        tokenExpirationDate = token.expirationDate
        accessToken = token.accessToken
    }
    
    func authorizationHeader() -> String {
        return token.tokenType + " " + accessToken
    }
    
    func refreshTokenIfNeeded(#id: String, completion: ((didRefresh: Bool, error: NSError?) -> Void)) {
        
        let isTokenValid = tokenExpirationDate > NSDate()
        if isTokenValid {
            completion(didRefresh: false, error: nil)
            return
        }
        
        var parameters = token.refreshParameters
        parameters["client_id"] = id
        
        Alamofire
            .request(.POST, "https://www.googleapis.com/oauth2/v3/token", parameters: parameters)
            .responseJSON { (_, _, data, error) in
            
            if let error = error {
                completion(didRefresh: false, error: error)
                return

            } else if let data: AnyObject = data {
                
                let json = JSON(data)
                
                if let accessToken = json["access_token"].string, expiresIn = json["expires_in"].int {
                    
                    self.tokenExpirationDate = NSDate().seconds + expiresIn
                    self.accessToken = accessToken
                    
                    completion(didRefresh: true, error: nil)
                    return
                }
            }
                
            let error = NSError(message: NSLocalizedString("Session expired. Please log in again.", comment: ""))
            completion(didRefresh: false, error: error)
        }
    }
}

private extension GTMOAuth2Authentication {
    
    var refreshParameters: [String : AnyObject] { return [
        "refresh_token" : refreshToken,
        "grant_type" : "refresh_token"
    ]}
}
