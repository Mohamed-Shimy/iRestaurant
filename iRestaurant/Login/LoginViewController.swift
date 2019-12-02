//
//  ViewController.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 27 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var loginButton: IButton!
    
    var manager: FirebaseManager!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let email: String = defaults.object(forKey: "email") as? String{
            let password: String = defaults.object(forKey: "password") as! String
            self.loginButton.showLoading()
            self.emailTextFeild.text = email
            self.passwordTextFeild.text = password
            self.manager = FirebaseManager(email: email, password: password, viewController: self, completion: { login , error in
                if login! || error == nil {
                    self.performSegue(withIdentifier: "GoToHome", sender: self)
                }else {
                    self.FireMessage(title: "Login Faild", content: (error?.localizedDescription)!, style: .alert)
                }
                self.loginButton.hideLoading()
            })
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func login(sender: UIButton)
    {
        let email = emailTextFeild.text!
        let password = passwordTextFeild.text!
        
        self.loginButton.showLoading()
        manager = FirebaseManager(email: email, password: password, viewController: self){ isLogin, error  in
            if error != nil{
                self.FireMessage(title: "Login Faild", content: (error?.localizedDescription)!, style: .alert)
                self.loginButton.hideLoading()
                return
            }
            
            let defaults = UserDefaults.standard
            let path = self.saveImageToDocument(name: "\(email).jpg", image: self.manager.image)
            
            defaults.set(email, forKey: "email")
            defaults.set(password, forKey: "password")
            if path.isNotEmpty{ defaults.set(path, forKey: "image") }
            
            self.loginButton.hideLoading()
            self.performSegue(withIdentifier: "GoToHome", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "GoToHome"
        {
            let homeTabBarController = segue.destination as! HomeTabBarController
            homeTabBarController.manager = manager
        }
    }
    
    func saveImageToDocument(name: String, image: UIImage) -> String
    {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(name)
        if let data = image.jpegData(compressionQuality:  1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
            } catch { return ""  }
        }
        return fileURL.absoluteString
    }
    
    @IBAction func signUp(sender: UIButton)
    {
        performSegue(withIdentifier: "GoToSignUp", sender: self)
    }
}

