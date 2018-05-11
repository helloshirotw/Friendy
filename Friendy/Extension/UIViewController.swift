//
//  UIViewController.swift
//  Friendy
//
//  Created by Gary Chen on 25/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit
import PKHUD
extension UIViewController {

    func getCurrentUser() -> User? {
        let userDefault = UserDefaults.standard
        let userData = userDefault.data(forKey: UserDefaultConstants.CURRENT_USER)
        
        if let user = NSKeyedUnarchiver.unarchiveObject(with: userData!) as? User {
            return user
        }
        return nil
    }
    
    static var alertController: UIAlertController!
    
    func displaySimpleAlert(title: String, message: String) {
        HUD.hide()
        if UIViewController.alertController != nil {
            dismissAlert()
        }
        UIViewController.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        UIViewController.alertController.addAction(okAction)
        self.present(UIViewController.alertController, animated: true, completion: nil)
    }
    
    private func dismissAlert() {
        UIViewController.alertController.dismiss(animated: true, completion: nil)
    }
    
}
