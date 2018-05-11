//
//  AccountCollectionViewCell.swift
//  Wellbet
//
//  Created by Gary Chen on 17/4/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

class HomeMenuCell: UICollectionViewCell {

    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isHighlighted: Bool {
        didSet {
            accountImageView.tintColor = isHighlighted ? .white : UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
            label.textColor = isHighlighted ? .white : UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
        }
    }
    override var isSelected: Bool {
        didSet {
            accountImageView.tintColor = isSelected ? .white : UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
            label.textColor = isSelected ? .white : UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
        }
    }
    
}
