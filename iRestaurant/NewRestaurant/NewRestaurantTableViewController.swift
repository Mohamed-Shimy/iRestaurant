//
//  NewRestaurantTableViewController.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 29 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

class NewRestaurantTableViewController: UITableViewController
{
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var visitedSwitchControl: UISwitch!
    
    var imagePicker: UIImagePickerController!
    var manager: FirebaseManager!
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController as! PassNavigationController
        manager = nav.manager
        restaurant = nav.restaurant
        manager.viewController = self
        
        SetupExistRestaurant()
        
        SetupImagePicker()
    }
    
    func SetupExistRestaurant()
    {
        if restaurant != nil
        {
            restaurantImageView.image = restaurant.image
            nameTextField.text = restaurant.name
            typeTextField.text = restaurant.type
            locationTextField.text = restaurant.location
            phoneTextField.text = restaurant.phone
            self.restaurantImageView.contentMode = .scaleAspectFill
        }
    }
    
    func SetupImagePicker()
    {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(OpenImagePicker))
        restaurantImageView.isUserInteractionEnabled = true
        restaurantImageView.addGestureRecognizer(imageTap)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @objc func OpenImagePicker(sender:Any)
    {
        self.present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {  return 1 }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 6 }
    
    @IBAction func close(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any)
    {
        let name = nameTextField.text!
        let type = typeTextField.text!
        let location = locationTextField.text!
        let phone = phoneTextField.text!
        let isVisited = visitedSwitchControl.isOn
        
        if name.isEmpty || type.isEmpty || location.isEmpty || phone.isEmpty
        {
            self.FireMessage(title: "", content: "Please fill all fields!", style: .alert)
            return
        }
        
        var restaurant: Restaurant
        if self.restaurant == nil
        {
            restaurant = Restaurant(name: name, type: type, location: location, phone: phone, isVisited: isVisited)
            restaurant.image = restaurantImageView.image!
        }
        else { restaurant = self.restaurant }
        
        manager.insert(restaurant: restaurant, completion: { backRestaurant, error  in
            if error != nil {
                self.FireMessage(title: "Error Saving Restaurant!", content: (error?.localizedDescription)!, style: .alert)
                return
            }
            restaurant = backRestaurant!
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
}
