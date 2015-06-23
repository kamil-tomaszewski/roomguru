//
//  GPPTokenStoreNetworkCoordinator.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GPPTokenStoreNetworkCoordinator {
    
    func refreshAccessToken(#parameters: [String: AnyObject], completion: ((tokenInfo: (accessToken: String, expirationDate: NSDate)?, error: NSError?)-> Void)) {
        
        Alamofire
            .request(.POST, Constants.GooglePlus.RefreshTokenURL, parameters: parameters)
            .responseJSON { (_, _, data, error) in
                
                if let error = error {
                    completion(tokenInfo: nil, error: error)
                    return
                    
                } else if let data: AnyObject = data {
                    
                    let json = JSON(data)
                    
                    if let accessToken = json["access_token"].string, expiresIn = json["expires_in"].int {
                        
                        let timeInterval = NSTimeInterval(expiresIn)
                        let tokenInfo = (accessToken: accessToken, expirationDate: NSDate().dateByAddingTimeInterval(timeInterval))
                        completion(tokenInfo: tokenInfo, error: error)
                        return
                    }
                }
                
                let error = NSError(message: NSLocalizedString("Session expired. Please log in again.", comment: ""))
                completion(tokenInfo: nil, error: error)
        }
    }
}
