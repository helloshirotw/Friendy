//
//  HomeDatasource.swift
//  TwitterLBTA
//
//  Created by Gary Chen on 6/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import LBTAComponents
import TRON
import SwiftyJSON

extension Collection where Iterator.Element == JSON {
    func decode<T: JSONDecodable>() throws -> [T] {
        return try map{try T(json: $0)}
    }
}

class HomeDatasource: Datasource, JSONDecodable {
    
    var users: [ActivityUser]
    var tweets: [Tweet]
    required init(json: JSON) throws {
        /*
         var users = [ActivityUser]()
         for userJSON in usersJSONArray! {
         let user = ActivityUser(json: userJSON)
         users.append(user)
         }
         self.users = users
         */
        
        guard let usersJSONArray = json["users"].array, let tweetsJSONArray = json["tweets"].array else {
            throw NSError(domain: "com.cybilltek", code: 1, userInfo: [NSLocalizedDescriptionKey: "Parsing JSON not valid in JSON."])
        }
        
//        self.users = usersJSONArray.map{ActivityUser(json: $0)}
//        self.tweets = tweetsJSONArray.map({Tweet(json: $0)})
        
        self.users = try usersJSONArray.decode()
        self.tweets = try tweetsJSONArray.decode()
        
    }

    
    override func footerClasses() -> [DatasourceCell.Type]? {
        return [ActivityUserFooter.self]
    }
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [ActivityUserHeader.self]
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [ActivityUserCell.self, TweetCell.self]
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        if indexPath.section == 1 {
            return tweets[indexPath.item]
        }
        
        return users[indexPath.item]
    }
    
    override func numberOfSections() -> Int {
        return 2
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        if section == 1{
            return tweets.count
        }
        return users.count
    }
}
