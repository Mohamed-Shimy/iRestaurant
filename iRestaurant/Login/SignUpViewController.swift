//
//  SignUpViewController.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 28 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController
{

    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signUpButton: IButton!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        backgroundImageView.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
       
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(OpenImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @objc func OpenImagePicker(sender:Any)
    {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func SignUp(sender: UIButton)
    {
        let email = emailTextField.text!
        let userName = userNameTextField.text!
        let password = passwordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        
        if userName.isEmpty {
            fireMessage(title: "SignUp Error", message: "Please enter user name!", style: .alert)
        }
        
        if password != confirmPassword
        {
            fireMessage(title: "SignUp Error", message: "Passwords not matched", style: .alert)
            return
        }
        
        self.signUpButton.showLoading()
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if authDataResult == nil || error != nil
            {
                self.fireMessage(title: "SignUp Error", message: (error?.localizedDescription)!, style: .alert)
                self.signUpButton.hideLoading()
                return
            }
            let uid = (authDataResult?.user.uid)!
            let nid = "\(userName.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil))_\(uid)"
            
            let defaults = UserDefaults.standard
            defaults.set(email, forKey: "email")
            defaults.set(password, forKey: "password")
            
            self.upload(self.profileImageView.image!,uid: nid, displayName: userName)
            {   url in
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = userName
                changeRequest?.photoURL = url
                changeRequest?.commitChanges{error in
                    if error != nil
                    {
                        self.fireMessage(title: "Error", message: (error?.localizedDescription)!, style: .alert)
                        self.signUpButton.hideLoading()
                        return
                    }
                }
                
                self.signUpButton.hideLoading()
            }
            
            self.dismiss(animated: true, completion: nil)
        }
       
    }
    
    func upload(_ image:UIImage,uid: String, displayName: String, completion: @escaping((_ url:URL?)->()))
    {
        let name = displayName.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
        let storageRef = Storage.storage().reference().child("user/\(uid)/\(name)")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(image.jpegData(compressionQuality: 80.0)!, metadata: metaData)
        {
            metaData,error in
            if error == nil && metaData != nil
            {
                storageRef.downloadURL(completion: { url, error in
                    error == nil ? completion(url) : completion(nil)
                })
            }
            else
            {
                completion(nil)
            }
        }
    }
    
    private func fireMessage(title: String, message: String, style: UIAlertController.Style)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func Login(sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
