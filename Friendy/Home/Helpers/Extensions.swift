//
//  Extensions.swift
//  yoututbe
//
//  Created by SnoopyKing on 2017/11/15.
//  Copyright © 2017年 SnoopyKing. All rights reserved.
//

import UIKit

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


extension UIView{
    func addConstriantFormat(format:String,views: UIView...){
        var viewsDic = [String:UIView]()
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDic[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDic))
    }
}

//let imageCache = NSCache<NSString,UIImage>()

class CustomImageView : UIImageView{
    
    var imageUrlString : String?
    
    func loadImageUsingUrlString(urlString: String){
        imageUrlString = urlString
        let url = URL(string: urlString)
        // Clear Image
        image = nil
        
        // First get image from cache
        if let imageFromCache = imageCache.object(forKey: urlString as NSString){
            self.image = imageFromCache
            return
        }
        
        // Cache Image
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                
                // Check the image url in cell is same with parameter url
                if self.imageUrlString == urlString {
                     self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
               
            })
        }).resume()
    }
}
