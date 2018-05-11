//
//  CustomTabBarController.swift
//  Friendy
//
//  Created by Gary Chen on 30/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let friendViewController = FriendViewController(nibName: ViewControllerConstants.FRIEND, bundle: nil)
        let friendNavController = createNavController(viewController: friendViewController, title: "Friend", imageName: "friend")

        let homeViewController = HomeViewController(nibName: ViewControllerConstants.HOME, bundle: nil)
        let homeNavController = createNavController(viewController: homeViewController, title: "Home", imageName: "home")
        
        let mapViewController = MapViewController(nibName: ViewControllerConstants.MAP, bundle: nil)
        let mapNavController = createNavController(viewController: mapViewController, title: "Map", imageName: "map")
        
        let notifyViewController = NotifyViewController(nibName: ViewControllerConstants.NOTIFY, bundle: nil)
        let notifyNavController = createNavController(viewController: notifyViewController, title: "Notify", imageName: "notify")
        
        let settingViewController = SettingViewController(nibName: ViewControllerConstants.SETTING, bundle: nil)
        let settingNavController = createNavController(viewController: settingViewController, title: "Setting", imageName: "setting")
        
        viewControllers = [friendNavController, homeNavController, mapNavController, notifyNavController, settingNavController]
        
    }
    
    private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(named: imageName)
        return navigationController
    }
    
}
