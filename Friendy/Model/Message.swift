//
//  Message.swift
//  Friendy
//
//  Created by Gary Chen on 1/5/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import Foundation
import Firebase

class Message: NSObject {
    var fromId: String?
    var toId: String?
    var text: String?
    var timestamp: Int?
    var imageUrl: String?
    
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    var videoUrl: String?
    
    init(dictionary: [String: AnyObject]) {
        self.fromId = dictionary["fromId"] as? String
        self.toId = dictionary["toId"] as? String
        self.text = dictionary["text"] as? String
        self.timestamp = dictionary["timestamp"] as? Int
        
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
        self.videoUrl = dictionary["videoUrl"] as? String
    }
    var chatParterId: String? {
        get {
            return fromId == Auth.auth().currentUser?.uid ? toId : fromId
        }
    }
    
}
