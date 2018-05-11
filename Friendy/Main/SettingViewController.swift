//
//  SettingViewController.swift
//  Friendy
//
//  Created by Gary Chen on 30/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingViewController: UIViewController {

    var customTabBarController: CustomTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout() {
        FirebaseManager.shared.logOut()
        
        let loginViewController = LoginViewController()
        customTabBarController?.viewControllers = []
        loginViewController.customTabBarController = customTabBarController
        present(loginViewController, animated: true, completion: nil)
    }
    

}
