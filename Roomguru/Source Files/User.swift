//
//  User.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 08/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class User: NSObject, NSSecureCoding {
    
    class var key: String { get { return "logged_user" } }
    
    private(set) var email: String = ""
    var id: String? = nil
    
    init(email: String) {
        self.email = email
    }
    
    required init(coder aDecoder: NSCoder) {
        email = aDecoder.decodeObjectForKey("email") as! String
        id = aDecoder.decodeObjectForKey("id") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(id, forKey: "id")
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
}
