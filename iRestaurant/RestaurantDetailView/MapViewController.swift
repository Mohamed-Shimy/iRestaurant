//
//  MapViewController.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 29 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet var mapView: MKMapView!
    var restaurant: Restaurant!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = restaurant.name
        mapView.delegate = self
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        
        self.initLocation()
    }
    
    func initLocation()
    {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location)
        {
            (placemarks, error) in
            if error != nil {
                print(error as Any)
                return
            }
            
            if let placemarks = placemarks
            {
                let placemark = placemarks[0]
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location
                {
                    annotation.coordinate = location.coordinate
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                    
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self)
        { return nil }
        
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil
        {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = restaurant.image//UIImage(named: restaurant.image)
        
        annotationView?.leftCalloutAccessoryView = leftIconView
        annotationView?.pinTintColor = UIColor.orange
        return annotationView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
