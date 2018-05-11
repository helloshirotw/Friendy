//
//  Usert.swift
//  TwitterLBTA
//
//  Created by Gary Chen on 8/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit
import SwiftyJSON
import TRON

struct ActivityUser: JSONDecodable {
    let name: String
    let username: String
    let bioText: String
    let profileImageUrl: String
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.username = json["username"].stringValue
        self.bioText = json["bio"].stringValue
        self.profileImageUrl = json["profileImageUrl"].stringValue

    }
}
