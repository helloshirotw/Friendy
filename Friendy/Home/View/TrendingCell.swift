//
//  TrendingCell.swift
//  youtube
//
//  Created by Gary Chen on 21/4/2018.
//  Copyright © 2018 SnoopyKing. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchTrendingFeed { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
