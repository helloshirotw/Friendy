//
//  AccountViewController.swift
//  Wellbet
//
//  Created by Gary Chen on 17/4/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var homeMenuView: HomeMenuView!
    
    @IBOutlet weak var collectionView: UICollectionView!

    let workoutTimerCellId = "workoutTimerCellId"
    let feedCellId = "feedCellId"
    let trendingCellId = "trendingCellId"
    let subscriptionCellId = "subscriptionCellId"
    let titles = ["Dog", "Cat", "Map", "Find"]
    var menuBarIndex: Int = 0
    var scrollViewDidEndDragging = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavTitle()
        setupNavBarButtons()
        homeMenuView.homeViewController = self
        setupCollectionView()
    }
    
    func setupNavTitle() {
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
    }
    
    func setupNavBarButtons(){
        let searchImg = UIImage(named: "icon_search")?.withRenderingMode(.alwaysTemplate)
        let searchBtn = UIBarButtonItem(image: searchImg, style: .plain, target: self, action: #selector(handleSearch))
        searchBtn.tintColor = .white
        let moreImg = UIImage(named: "icon_more")?.withRenderingMode(.alwaysTemplate)
        let moreBtn = UIBarButtonItem(image: moreImg, style: .plain, target: self, action: #selector(handleMore))
        moreBtn.tintColor = .white
        
        navigationItem.rightBarButtonItems = [moreBtn,searchBtn]
        
    }
    
    let settingLauncher = SettingLauncher()
    
    @objc func handleMore(){
        settingLauncher.showSettings()
    }
    
    @objc func handleSearch(){
        scrollToMenuIndex(menuIndex: 2)
    }
    
    private func setupCollectionView() {
        
//        collectionView?.backgroundColor = UIColor.lightGray
        let nib = UINib(nibName: "WorkoutTimerCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: workoutTimerCellId)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: feedCellId)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        self.menuBarIndex = menuIndex
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: false)
        setTitleForIndex(index: menuIndex)
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier: String
        /*let vc = UIViewController()
        vc.view.backgroundColor = .red
        cell.contentView.addSubview(vc.view)*/
        
        switch indexPath.item {
        case 0:
            identifier = trendingCellId
        case 1:
            identifier = subscriptionCellId
        case 2:
            identifier = feedCellId
        default:
            identifier = workoutTimerCellId
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    
}


extension HomeViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scrollViewDidEndDragging {

            let nextIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            
            let pageContentOffSet = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.frame.width)
            
            if menuBarIndex > nextIndex {
                
                homeMenuView.horizontalBarLeftAnchorConstraint?.constant =
                    CGFloat(menuBarIndex) * scrollView.frame.width / 4 -  (scrollView.frame.width - pageContentOffSet) / 4
                
                homeMenuView.horizontalBarWidthAnchorConstraint?.constant =
                    homeMenuView.frame.width / 4 + (scrollView.frame.width - pageContentOffSet) / 4
            } else {
                homeMenuView.horizontalBarWidthAnchorConstraint?.constant =
                    homeMenuView.frame.width / 4 + pageContentOffSet / 4
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        menuBarIndex = Int(targetContentOffset.pointee.x / collectionView.frame.width)
        
        homeMenuView.horizontalBarLeftAnchorConstraint?.constant = homeMenuView.frame.width / 4 * CGFloat(menuBarIndex)
        
        setTitleForIndex(index: menuBarIndex)
        
        scrollViewDidEndDragging = true
        
    }
    
    private func setTitleForIndex(index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[index])"
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        homeMenuView.horizontalBarWidthAnchorConstraint?.constant = homeMenuView.frame.width / 4
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.homeMenuView.layoutIfNeeded()
        }, completion: nil)
        let indexPath = IndexPath(item: menuBarIndex, section: 0)
            
        homeMenuView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndDragging = false
    }
    
}
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - homeMenuView.frame.height)
    }
    
}


