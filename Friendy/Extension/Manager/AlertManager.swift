//
//  AlertManager.swift
//  Friendy
//
//  Created by Gary Chen on 25/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit

class AlertManager: NSObject {
    
    static let shared = AlertManager()
    private var alertController: UIAlertController!
    
    func displaySimpleAlert(title: String, message: String, viewController: UIViewController) {
        
        if alertController != nil {
            dismissAlert()
        }
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    private func dismissAlert() {
        alertController.dismiss(animated: true, completion: nil)
    }
    
}
