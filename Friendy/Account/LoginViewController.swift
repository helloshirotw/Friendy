//
//  LoginViewController.swift
//  Friendy
//
//  Created by Gary Chen on 24/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import PKHUD
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginViewYConstaint: NSLayoutConstraint!

    var avPlayer: AVPlayer?
    var customTabBarController: CustomTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email", "public_profile"]
        fbLoginButton.loginBehavior = .web
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
        avPlayer?.pause()
    }
    
    func setupInterface() {

        loginButton.setCorner(radius: 10)
        
        if let videoUrl = Bundle.main.url(forResource:"defaultVideo", withExtension: "mp4") {
            avPlayer = AVPlayer(url: videoUrl)
            view.setVideo(avPlayer!)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        HUD.show(.progress)
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                self.displaySimpleAlert(title: "Login Fail", message: error!.localizedDescription)
                return
            }
            // Successfully logged in
            self.customTabBarController?.login()
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        loginViewYConstaint.animate(100, self.view)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        loginViewYConstaint.animate(150, self.view)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        loginViewYConstaint.animate(100, self.view)
    }

}

extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }

    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        checkFBUser()
    }

    func checkFBUser() {
        //"EAAdPHaZBIJtwBAIr3aJPoWfhav1qrXfK9BLFGBO5fpF0zqnAClvFVWgU2HKc5rgwLttJbAiLlwuxmTnay71bwZAZBvqAOiXUr5523lLFBi8W0Os58mHqjVjpajy9SJM9KyUpW2NiuKotIBvd2F9RCi2NIxaZAAgNCAYPZAB0q7hhQjoPzB0rXsbZClozIPrNZBCNhdKZAqSD9QZDZD"
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        HUD.show(.progress)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in

            if error != nil {
                print("Something went wrong with our FB user: ", error!)
                return
            }
            
            guard let uid = user?.uid else { return }

            FirebaseManager.usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if !snapshot.hasChild(uid) {
                    // If user sign in first time
                    self.getUserFBInfo(completion: { (values) in
                        self.registerUser(uid, values)
                    })
                } else {
                    self.customTabBarController?.login()
                    HUD.hide()
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
        })
    }
    
    func getUserFBInfo(completion: @escaping ([String : NSObject]) -> Void) {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "name, email, picture"]).start { (connection, result, err) in
            if err != nil {
                print("Failed to start graph request", err!)
                return
            }
            if let dic = result as? [String: AnyObject] {
                let email = dic["email"] as? String
                let name = dic["name"] as? String
                let picture = dic["picture"] as! [String: Any]
                let picData = picture["data"] as! [String: Any]
                let profileImageUrl = picData["url"] as! String
                
                let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl] as! [String: NSObject]
                
                completion(values)
            }
        }

    }
    
    private func registerUser(_ uid: String, _ values: [String: NSObject]) {
        let usersReference = FirebaseManager.usersRef.child(uid)
        usersReference.updateChildValues(values) { (error, reference) in
            guard error == nil else { return }
            print(reference)
            self.customTabBarController?.login()
            HUD.hide()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

