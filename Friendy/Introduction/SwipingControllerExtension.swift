//
//  SwipingControllerExtension.swift
//  Auto Layout Programmatically
//
//  Created by SnoopyKing on 2017/11/12.
//  Copyright © 2017年 SnoopyKing. All rights reserved.
//

import UIKit
extension SwipingController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()
            if self.pageControl.currentPage == 0{
                self.collectionView?.contentOffset = .zero
            }else{
                
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }) { (_) in
        }
    }
}
