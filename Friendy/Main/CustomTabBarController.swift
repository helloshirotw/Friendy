
//  CustomTabBarController.swift
//  Friendy
//
//  Created by Gary Chen on 30/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class CustomTabBarController: UITabBarController {

    
    var userDefault = UserDefaults.standard
    var isLogOut = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCurrentUser()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    
    private func setViewControllers() {
        
        let friendViewController = FriendViewController(nibName: ViewControllerConstants.FRIEND, bundle: nil)
        let homeViewController = HomeViewController(nibName: ViewControllerConstants.HOME, bundle: nil)
        let mapViewController = MapViewController(nibName: ViewControllerConstants.MAP, bundle: nil)
//        let notifyViewController = NotifyViewController(nibName: ViewControllerConstants.NOTIFY, bundle: nil)
        let settingViewController = SettingViewController(nibName: ViewControllerConstants.SETTING, bundle: nil)

        
        
        let friendNavController = createNavController(viewController: friendViewController, title: "Friend", imageName: "friend")
        
        let mapNavController = createNavController(viewController: mapViewController, title: "Map", imageName: "map")
        
        let homeNavController = createNavController(viewController: homeViewController, title: "Home", imageName: "home")
        
//        let notifyNavController = createNavController(viewController: notifyViewController, title: "Notify", imageName: "notify")
        
        let settingNavController = createNavController(viewController: settingViewController, title: "Setting", imageName: "settings")
        
        let activityViewController = ActivityViewController()
        let activityNavController = createNavController(viewController: activityViewController, title: "Activity", imageName: "notify")
        viewControllers = [friendNavController, mapNavController, homeNavController, activityNavController, settingNavController]
    }
    
    private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(named: imageName)
        return navigationController
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        guard let index = tabBar.items?.index(of: item),
            let navController = viewControllers![index] as? UINavigationController else { return }

        let viewController = navController.topViewController
        
        switch viewController {
            
        case is FriendViewController:
//            friendViewController.user = user
            break
        case is MapViewController:
            break
        case is HomeViewController:
            break
            
        case is NotifyViewController:
            break
            
        default:
            guard let navController = self.viewControllers![4] as? UINavigationController else { return }
            if let settingViewController = navController.topViewController as? SettingViewController {
                settingViewController.customTabBarController = self
            }
        }
    }

    func login() {
        checkCurrentUser()
    }
    
}

// Firebase logic
extension CustomTabBarController {
    private func checkCurrentUser() {
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(logout), with: nil, afterDelay: 0)
        } else {
            fetchCurrentUser()
        }
        
    }
    
    @objc func logout() {
        FirebaseManager.shared.logOut()
        let loginViewController = LoginViewController()
        loginViewController.customTabBarController = self
        present(loginViewController, animated: true, completion: nil)
    }
    
    
    private func setUserToUserDefault(dic: [String: AnyObject]) {
        let user = User(dictionary: dic)
        let userData = NSKeyedArchiver.archivedData(withRootObject: user)
        self.userDefault.removeObject(forKey: UserDefaultConstants.CURRENT_USER)
        self.userDefault.set(userData, forKey:
            UserDefaultConstants.CURRENT_USER)
        setViewControllers()
        self.selectedIndex = 2
        HUD.hide()
    }
    
    func fetchCurrentUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirebaseManager.usersRef.child(uid).observeSingleEvent(of: .value) { (snapShot) in
            if let dic = snapShot.value as? [String: AnyObject] {
                self.setUserToUserDefault(dic: dic)
            }
        }
    }
}
