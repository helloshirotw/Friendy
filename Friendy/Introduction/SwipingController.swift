//
//  SwipingController.swift
//  Auto Layout Programmatically
//
//  Created by SnoopyKing on 2017/11/11.
//  Copyright © 2017年 SnoopyKing. All rights reserved.
//
//Controller
import UIKit

class SwipingController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    
    
    let pages = [
        Page(imgName: "KarenAndGary1", headerText: "Welcome to Company XYZ", bodyText: "Are you looking for anyone? Don't hesitate and longer!! We hope you have fun in our apps!!"),
        Page(imgName: "KarenAndGary2", headerText: "Try to find someone near from you!!", bodyText: "Hello there! Thanks so much for downloading our brand new app and giving us a try. Make sure to leave us a good review in the AppStore"),
        Page(imgName: "KarenAndGary3", headerText: "This is a great chance for you", bodyText: "bbbbbxgs;aofgj sfg isdjk dsfkgu vxoubxo cjbvi ujcvxi u sklfdjn askfdaiu falsdfoua kcuv hcou oc"),
    ]

    fileprivate func setupBtnControls(){
        
        let bottomStackViewController = UIStackView(arrangedSubviews: [priviousBtn,pageControl,nextBtn])
        view.addSubview(bottomStackViewController)
        bottomStackViewController.translatesAutoresizingMaskIntoConstraints = false
        bottomStackViewController.distribution = .fillEqually

        NSLayoutConstraint.activate([
            bottomStackViewController.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomStackViewController.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomStackViewController.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomStackViewController.heightAnchor.constraint(equalToConstant: 80)
            ])
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentIndex = self.pageControl.currentPage
        if currentIndex == self.pages.endIndex - 1 {
            self.nextBtn.setTitle("Done", for: .normal)
        } else {
            self.nextBtn.setTitle("Next", for: .normal)
        }
    }
    
    let priviousBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Prev", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.gray, for: .normal)
        btn.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        return btn
    }()
    let nextBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return btn
    }()
    
    @objc private func handleNext(){
        if nextBtn.titleLabel!.text! == "Done" {
            let customTabBarController = CustomTabBarController()
            dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(customTabBarController, animated: true, completion: nil)
        } else {
            
            textAnimations()
        }
    }
    
    func textAnimations() {
        let pageIndex = self.pageControl.currentPage
        let cell = self.collectionView?.cellForItem(at: IndexPath(item: pageIndex, section: 0)) as! PageCell
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            cell.headerLabel.transform = CGAffineTransform(translationX: -30, y: 0)
            
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                cell.headerLabel.alpha = 0
                cell.headerLabel.transform = cell.headerLabel.transform.translatedBy(x: 0, y: -200)
            })
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            cell.bodyLabel.transform = CGAffineTransform(translationX: -30, y: 0)
            
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                cell.bearImageView.alpha = 0
                cell.bodyLabel.alpha = 0
                cell.bodyLabel.transform = cell.bodyLabel.transform.translatedBy(x: 0, y: -200)
            }, completion: { (completion) in
                self.priviousBtn.isEnabled = false
                self.priviousBtn.alpha = 0
                
                let nextIndex = min(self.pageControl.currentPage + 1, self.pages.count - 1)
                let indexPath = IndexPath(item: nextIndex, section: 0)
                self.pageControl.currentPage = nextIndex
                if nextIndex == self.pages.endIndex - 1 {
                    self.nextBtn.setTitle("Done", for: .normal)
                }
                self.collectionView?.isScrollEnabled = false
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            })
        }
    }
    
    @objc private func handlePrevious(){
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        let previousIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: previousIndex, section: 0)
        pageControl.currentPage = previousIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = UIColor.red
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBtnControls()
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView?.isPagingEnabled = true
    }
}
