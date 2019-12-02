//
//  UpdateTableViewController.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 18 November, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit
import Firebase

class UpdateTableViewController: UITableViewController
{
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var visitedSwitchControl: UISwitch!
    @IBOutlet weak var favoriteSwitchControl: UISwitch!
    @IBOutlet weak var rateStepper: UIStepper!
    @IBOutlet weak var rateLabel: UILabel!
    
    var imagePicker: UIImagePickerController!
    var manager: FirebaseManager!
    var restaurant: Restaurant!
    
    var oldImage : UIImage!
    var oldName = ""
    var oldType = ""
    var oldLocation = ""
    var oldPhone = ""
    var oldRate : Float = 0.0
    var oldIsVisited = false
    var oldIsFavorite = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let nav = self.navigationController as! PassNavigationController
        manager = nav.manager
        restaurant = nav.restaurant
       
        self.title = "Update \(restaurant.name)"
        
        restaurantImageView.image = restaurant.image
        nameTextField.text = restaurant.name
        typeTextField.text = restaurant.type
        locationTextField.text = restaurant.location
        phoneTextField.text = restaurant.phone
        visitedSwitchControl.setOn(restaurant.isVisited, animated: true)
        favoriteSwitchControl.setOn(restaurant.isFavorite, animated: true)
        rateStepper.value = Double(restaurant.rating)
        stepperValueChanged(rateStepper)
        
        oldImage = restaurant.image
        oldName = restaurant.name
        oldType = restaurant.type
        oldLocation = restaurant.location
        oldPhone = restaurant.phone
        oldRate = restaurant.rating
        oldIsVisited = restaurant.isVisited
        oldIsFavorite = restaurant.isFavorite
        
        manager.viewController = self
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(OpenImagePicker))
        restaurantImageView.isUserInteractionEnabled = true
        restaurantImageView.addGestureRecognizer(imageTap)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 8 }
    
    @objc func OpenImagePicker(sender:Any)
    {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func close(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        rateLabel.text = "\(Float(round(rateStepper.value*10)/10))"
    }
    
    @IBAction func update(_ sender: Any)
    {
        let image = restaurantImageView.image
        let name = nameTextField.text!
        let type = typeTextField.text!
        let location = locationTextField.text!
        let phone = phoneTextField.text!
        let rate = Float(rateStepper.value)
        let isVisited = visitedSwitchControl.isOn
        let isFavorite = favoriteSwitchControl.isOn
        
        if name.isEmpty || type.isEmpty || location.isEmpty || phone.isEmpty
        {
            self.FireMessage(title: "", content: "Please fill all fields!", style: .alert)
            return
        }
        
        var data: [String: Any] = [:]
        var isEdit = false
        
        if name != oldName{
            data["Name"] = name
            restaurant.name = name
            isEdit = true
        }
        if type != oldType{
            data["Type"] = type
            restaurant.type = type
            isEdit = true
        }
        if location != oldLocation{
            data["Location"] = location
            restaurant.location = location
            isEdit = true
        }
        if phone != oldPhone{
            data["Phone"] = phone
            restaurant.phone = phone
            isEdit = true
        }
        if rate != oldRate{
            data["Rating"] = rate
            restaurant.rating = rate
            isEdit = true
        }
        if isFavorite != oldIsFavorite{
            data["IsFavorite"] = isFavorite
            restaurant.isFavorite = isFavorite
            isEdit = true
        }
        if isVisited != oldIsVisited{
            data["IsVisited"] = isVisited
            restaurant.isVisited = isVisited
            isEdit = true
        }
        
        if (oldImage == nil && image != nil) || image?.pngData() != oldImage.pngData(){
            restaurant.image = image
        
            self.manager.updateImage(restaurantID: restaurant.ID, oldImagePath: restaurant.imagePath, image: image!) { (url, error) in
                if error == nil{
                    self.restaurant.imagePath = url!
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        if isEdit{
            manager.update(restaurantID: restaurant.ID, newValue: data, completion: {error in
                if error != nil{
                    self.FireMessage(title: "Error Updating Restaurant!", content: (error?.localizedDescription)!, style: .alert)
                }
                else{
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
       
    }
}
