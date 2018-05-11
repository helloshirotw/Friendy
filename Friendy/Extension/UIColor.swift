//
//  UIColor.swift
//  Friendy
//
//  Created by Gary Chen on 1/5/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    static let pinkColor = UIColor(r: 255, g: 192, b: 203)
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
