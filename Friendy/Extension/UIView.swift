//
//  UIView.swift
//  Friendy
//
//  Created by Gary Chen on 24/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit
import AVFoundation

extension UIView {
    
    func setCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func setVideo(_ avPlayer: AVPlayer) {
        
        var avPlayerLayer: AVPlayerLayer!
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        avPlayerLayer.frame = UIScreen.main.bounds
        self.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,selector: #selector(playerItemDidReachEnd(notification:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: avPlayer.currentItem)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero, completionHandler: nil)
    }
    
}
