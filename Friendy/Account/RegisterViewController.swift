//
//  RegisterViewController.swift
//  Friendy
//
//  Created by Gary Chen on 24/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerViewYContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    @IBAction func imageViewTapped(_ sender: UIButton) {
        selectProfileImageView()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else { return }
        
        HUD.show(.progress)
        if email == "" || password == "" || name == "" {
            
            displaySimpleAlert(title: "Create Account Fail", message: "Please enter your informations.")
        } else if imageView.image == UIImage(named: "add_image") {
            
            displaySimpleAlert(title: "Create Account Fail", message: "Please upload your image.")
        } else {
            register(email: email, password: password, name: name)
        }
        
    }
    
    private func register(email: String, password: String, name: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                self.displaySimpleAlert(title: "Create Account Fail", message: error!.localizedDescription)
                return
            }
            
            guard let uid = user?.uid else { return }
            
            self.uploadImage(completion: { (profileImageUrl) in
                let values = ["name": name, "email": email, "password": password, "profileImageUrl": profileImageUrl] as [String: NSObject]
                self.registerUser(uid, values)
            })
            
        }
    }
    
    private func uploadImage(completion: @escaping (String) -> Void) {
        
        // Put profile image into database storage
        let imageName = NSUUID().uuidString
        
        let profileImageRef = FirebaseManager.profileImageStorageRef.child("\(imageName).png")
        
        if let profileImage = self.imageView.image,
            let jpegData = UIImageJPEGRepresentation(profileImage, 0.2) {
            profileImageRef.putData(jpegData, metadata: nil, completion: { (metadata, error) in
                guard error == nil else { return }
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                
                completion(profileImageUrl)
            })
        }
    }
    
    var customTabBarController: CustomTabBarController?
    
    private func registerUser(_ uid: String, _ values: [String: NSObject]) {
        let usersReference = FirebaseManager.usersRef.child(uid)
        usersReference.updateChildValues(values) { (error, reference) in
            guard error == nil else { return }
            self.customTabBarController?.login()

            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)

        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func selectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        imageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        registerViewYContraint.animate(60, self.view)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        registerViewYContraint.animate(150, self.view)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        registerViewYContraint.animate(60, self.view)
    }
    
}
