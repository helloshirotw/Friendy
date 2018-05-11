//
//  Tweet.swift
//  TwitterLBTA
//
//  Created by Gary Chen on 9/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

struct Tweet: JSONDecodable {
    let user: ActivityUser
    let message: String
    
    init(json: JSON) {
        self.user = ActivityUser(json: json["user"])
        self.message = json["message"].stringValue
    }
}
