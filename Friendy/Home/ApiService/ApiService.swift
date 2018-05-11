//
//  File.swift
//  youtube
//
//  Created by Gary Chen on 20/4/2018.
//  Copyright © 2018 SnoopyKing. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    static let sharedInstance = ApiService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/home.json", completion: completion)
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/subscriptions.json", completion: completion)
    }
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video]) -> ()) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
        if error != nil{
            print(error!)
            return
        }
        do{
            guard data != nil else { return }
            guard let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String:NSObject]] else { return }
            
            var videos = [Video]()
            
            
            for dic in json{
            
                let video = Video()
                video.title = dic["title"] as? String
                video.thumbnail_image_name = dic["thumbnail_image_name"] as? String
                video.number_of_views = dic["number_of_views"] as? NSNumber
                
                let channelDic = dic["channel"] as! [String : NSObject]
                let channel = Channel()
                channel.profile_image_name = channelDic["profile_image_name"] as? String
                channel.name = (channelDic["name"] as! String)
                
                video.channel = channel
                videos.append(video)
            }
            
            DispatchQueue.main.async(execute: {
                completion(videos)
            })
            
        }catch let jsonError{
            print(jsonError)
        }
        }.resume()
    }
    
}
