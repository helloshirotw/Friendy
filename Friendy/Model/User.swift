//
//  User.swift
//  Friendy
//
//  Created by Gary Chen on 25/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    
    required init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.password = dictionary["password"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.name = aDecoder.decodeObject() as? String
        self.email = aDecoder.decodeObject() as? String
        self.password = aDecoder.decodeObject() as? String
        self.profileImageUrl = aDecoder.decodeObject() as? String
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name)
        aCoder.encode(email)
        aCoder.encode(password)
        aCoder.encode(profileImageUrl)
    }
    var id: String?
    var name: String?
    var email: String?
    var password: String?
    var profileImageUrl: String?
    
}
