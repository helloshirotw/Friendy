//
//  AccountMenuBarView.swift
//  Wellbet
//
//  Created by Gary Chen on 23/4/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

class HomeMenuView: UIView {
    
    let homeMenuCell = "homeMenuCell"
    let imageNames = ["icon_dog","icon_cat","icon_position","icon_map"]
    let labelNames = ["狗狗", "貓貓", "尋找", "附近"]
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    var horizontalBarWidthAnchorConstraint: NSLayoutConstraint?
    var selectedIndexPath: IndexPath?
    var homeViewController: HomeViewController?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(collectionView)
        
        let menu = UINib(nibName: "HomeMenuCell", bundle: nil)
        collectionView.register(menu, forCellWithReuseIdentifier: homeMenuCell)
        
        collectionView.fillSuperview()
        
        selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        
        setupHorizontalBar()
    }
    
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        horizontalBarWidthAnchorConstraint = horizontalBarView.widthAnchor.constraint(equalToConstant: self.frame.width / 4)
        
        horizontalBarWidthAnchorConstraint?.isActive = true
        
        horizontalBarView.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
}


extension HomeMenuView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         let x = CGFloat(indexPath.item) * frame.width / 4
         //Animation when user tapped
         if indexPath.item < (selectedIndexPath?.row)! {
            horizontalBarLeftAnchorConstraint?.constant = x
         }
         let distance = CGFloat(abs(indexPath.item - (selectedIndexPath?.row)!) + 1)
         horizontalBarWidthAnchorConstraint?.constant = self.frame.width / 4 * distance
         layoutIfNeeded()
         //One secound animation after user tapped
         
         horizontalBarLeftAnchorConstraint?.constant = x
        
         horizontalBarWidthAnchorConstraint?.constant = self.frame.width / 4
        
         UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
         }, completion: nil)
        
        selectedIndexPath = indexPath
        
        homeViewController?.scrollToMenuIndex(menuIndex: indexPath.item)
        
    }
    
}

extension HomeMenuView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeMenuCell, for: indexPath) as! HomeMenuCell
        cell.accountImageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.label.text = labelNames[indexPath.item]
        return cell
    }
}

extension HomeMenuView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension UIView {
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
}
