//
//  SubscriptionCell.swift
//  youtube
//
//  Created by Gary Chen on 21/4/2018.
//  Copyright © 2018 SnoopyKing. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    override func fetchVideos() {
        ApiService.sharedInstance.fetchSubscriptionFeed { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
