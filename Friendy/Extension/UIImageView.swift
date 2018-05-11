//
//  UIImageView.swift
//  Friendy
//
//  Created by Gary Chen on 30/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func cacheImage(urlString: String) {
        self.image = nil
        
        if let cacheImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cacheImage
        } else {
            downloadImage(urlString: urlString)
        }
    }
    
    private func downloadImage(urlString: String) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard error == nil else { return }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            }
            
        }.resume()
    }
}

