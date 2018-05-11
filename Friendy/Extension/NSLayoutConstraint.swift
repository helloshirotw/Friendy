//
//  NSLayoutConstraint.swift
//  Friendy
//
//  Created by Gary Chen on 24/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    func animate(_ constant: CGFloat, _ view: UIView) {
        self.constant = constant
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            view.layoutIfNeeded()
        }, completion: nil)
    }
    
}
