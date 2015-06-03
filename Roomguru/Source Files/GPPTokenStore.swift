//
//  GPPTokenStore.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 31/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DateKit

/* NOTICE:
* This class is workaround for g+ issue with refreshing token.
* Raw request is used.
* Please use accessToken from this class (not GTMOAuth2Authentication.accessToken).
*/

class GPPTokenStore {
    
    private var auth: GTMOAuth2Authentication
    
    private(set) var tokenExpirationDate: NSDate
    private(set) var accessToken: String
    
    var networkCoordinator = GPPTokenStoreNetworkCoordinator()
    
    init(auth: GTMOAuth2Authentication) {
        self.auth = auth
        
        tokenExpirationDate = auth.expirationDate
        accessToken = auth.accessToken
    }
    
    func authorizationHeader() -> String {
        return auth.tokenType + " " + accessToken
    }
    
    func refreshTokenIfNeeded(#id: String, completion: ((didRefresh: Bool, error: NSError?) -> Void)) {
        
        let isTokenValid = tokenExpirationDate > NSDate()
        if isTokenValid {
            completion(didRefresh: false, error: nil)
            return
        }
        
        var parameters = auth.refreshParameters
        parameters["client_id"] = id
        
        networkCoordinator.refreshAccessToken(parameters: parameters) { (tokenInfo, error) in
            
            var didRefresh = false
            
            if let tokenInfo = tokenInfo {
                didRefresh = true
                
                self.tokenExpirationDate = tokenInfo.expirationDate
                self.accessToken = tokenInfo.accessToken
                
            }
            
            completion(didRefresh: didRefresh, error: error)
        }
    }
}

private extension GTMOAuth2Authentication {
    
    var refreshParameters: [String : AnyObject] { return [
        "refresh_token" : refreshToken,
        "grant_type" : "refresh_token"
    ]}
}