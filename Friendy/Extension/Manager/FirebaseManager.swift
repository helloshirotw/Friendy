//
//  File.swift
//  Friendy
//
//  Created by Gary Chen on 30/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    static let usersRef = Database.database().reference().child("users")
    static let messagesRef = Database.database().reference().child("messages")
    static let userMessagesRef = Database.database().reference().child("user_messages")
    static let profileImageStorageRef = Storage.storage().reference().child("profile_images")
    static let messageVideoStorageRef = Storage.storage().reference().child("message_videos")
    static let messageImageStorageRef =
        Storage.storage().reference().child("message_images")
    func logOut() {
        UserDefaults.standard.removeObject(forKey: UserDefaultConstants.CURRENT_USER)
        
        do {
            try Auth.auth().signOut()
            
            if let _ = FBSDKAccessToken.current() {
                FBSDKLoginManager().logOut()
            }
        } catch let error {
            print(error)
        }
        
    }
}

