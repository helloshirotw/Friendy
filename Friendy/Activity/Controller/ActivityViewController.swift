//
//  HomeDatasourceController.swift
//  TwitterLBTA
//
//  Created by Gary Chen on 6/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//
import UIKit
import LBTAComponents
import TRON
import SwiftyJSON

class ActivityViewController: DatasourceController {
    
    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Error 404"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        view.addSubview(errorMessageLabel)
        errorMessageLabel.fillSuperview()
        
        collectionView?.backgroundColor = UIColor(r: 232, g: 236, b: 241)
        
//        let homeDatasource = HomeDatasource()
//        self.datasource = homeDatasource
        
        Service.sharedInstance.fetchHomeFeed { (homeDatasource, err) in
            if let _ = err {
                self.errorMessageLabel.isHidden = false
                if let apiError = err as? APIError<Service.JSONError> {
                    if apiError.response?.statusCode == 200 {
                        self.errorMessageLabel.text = "Error 200"
                    }
                }
                return
            }
            self.datasource = homeDatasource
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {
            
            guard let user = self.datasource?.item(indexPath) as? ActivityUser else { return .zero }
        
            let estimatedHeight = estimatedHeightForText(user.bioText)
            
            return CGSize(width: view.frame.width, height: estimatedHeight + 66)
        
        } else if indexPath.section == 1 {
            
            guard let tweet = datasource?.item(indexPath) as? Tweet else { return .zero }
            
            let estimatedHeight = estimatedHeightForText(tweet.message)
            
            return CGSize(width: view.frame.width, height: estimatedHeight + 74)
        }

        return CGSize(width: view.frame.width, height: 200)
    }
    
    private func estimatedHeightForText(_ text: String) -> CGFloat {
        let size = CGSize(width: view.frame.width - 76, height: 1000)
        
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], context: nil)
        
        return estimatedFrame.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return .zero
        }
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {if section == 1 {
        return .zero
        }
        return CGSize(width: view.frame.width, height: 64)
    }
    
}


