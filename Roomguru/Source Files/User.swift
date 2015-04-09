//
//  User.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 08/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

protocol Persistence {
    
    static var key: String { get }
    
    func save()
    func delete() -> Bool
}

class User: NSObject, NSSecureCoding {
    
    private(set) var email: String = ""
    class var current: User? {
        get {
            if let data = Defaults[key].data {
                return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
            }
            return nil
        }
    }
    
    init(email: String) {
        self.email = email
    }
    
    required init(coder aDecoder: NSCoder) {
        email = aDecoder.decodeObjectForKey("email") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(email, forKey: "email")
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
}

// MARK: Private

extension User {
    
    private func googlePlusService(auth: GTMOAuth2Authentication) -> GTLServicePlus {
        let service = GTLServicePlus()
        service.retryEnabled = true
        service.authorizer = auth
        service.apiVersion = "v1"
        return service
    }
}


// MARK: Persistance

extension User: Persistence {
    
    class var key: String { get { return "logged_user" } }
    
    func save() {
        Defaults[User.key] = NSKeyedArchiver.archivedDataWithRootObject(self)
        Defaults.synchronize()
    }
    
    func delete() -> Bool {
        if Defaults.hasKey(User.key) {
            Defaults.remove(User.key)
            Defaults.synchronize()
            return true
        }
        return false
    }
}
