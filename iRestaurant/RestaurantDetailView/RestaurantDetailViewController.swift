//
//  RestaurantDetailViewController.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 29 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var favoriteImageView: UIImageView!
    @IBOutlet var isVisitedImageView: UIImageView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var updateButton: UIBarButtonItem!
    
    var manager: FirebaseManager!
    var restaurant: Restaurant!
    var rating: Double!
    var isNewRestaurant: Bool = false
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if isNewRestaurant{ updateButton.image = UIImage(named: "add30") }
            
        title = restaurant.name
        restaurantImageView.image = restaurant.image//UIImage(named: restaurant.image)
        favoriteImageView.image = restaurant.isFavorite ? UIImage(named: "lace") : nil
        isVisitedImageView.image = restaurant.isVisited ? UIImage(named: "checked") : nil
        // Map
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        if restaurant.image != nil{
            self.tableView.backgroundView = Colors.BlurEffectView(image: restaurant.image!, frame: self.view.bounds, contentMode: .scaleAspectFill, style: .dark)
        }
        
        //Geocoder
       self.initLocation()
    }
    
    func initLocation()
    {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location, completionHandler:
            {
                placemarks, error in
                
                if error != nil  {  return }
                
                if let placemarks = placemarks
                {
                    let placemark = placemarks[0]
                    
                    let annotation = MKPointAnnotation()
                    if let location = placemark.location
                    {
                        annotation.coordinate = location.coordinate
                        self.mapView.addAnnotation(annotation)
                        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                        self.mapView.setRegion(region, animated: false)
                    }
                }
        })
    }
    
    @objc func showMap()
    {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    @IBAction func Edit()
    {
        if isNewRestaurant{
            performSegue(withIdentifier: "GoToNewRestaurant", sender: self)
        }else{ performSegue(withIdentifier: "GoToUpdate", sender: self)}
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        self.manager.viewController = self
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RDCell", for: indexPath) as! RestaurantDetailTableViewCell
        
        switch indexPath.row
        {
        case 0:
            cell.fieldImage.image = UIImage(named: "user")
            cell.valueLable.text = restaurant.name
        case 1:
            cell.fieldImage.image = UIImage(named: "type")
            cell.valueLable.text = restaurant.type
        case 2:
            cell.fieldImage.image = UIImage(named: "marker_light")
            cell.valueLable.text = restaurant.location
        case 3:
            cell.fieldImage.image = UIImage(named: "phone")
            cell.valueLable.text = restaurant.phone
        default:
            cell.fieldImage.image = nil
            cell.valueLable.text = ""
        }
        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showMap"
        {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
        }
        else if segue.identifier == "GoToUpdate"
        {
            let destinationController = segue.destination as! PassNavigationController
            destinationController.restaurant = restaurant
            destinationController.manager = self.manager
        }
        else if segue.identifier == "GoToNewRestaurant"
        {
            let destinationController = segue.destination as! PassNavigationController
            destinationController.manager = self.manager
            destinationController.restaurant = restaurant
        }
    }

}
