//
//  Restaurant.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 29 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

class Restaurant: NSObject
{
    var ID = ""
    var name = ""
    var type = ""
    var location = ""
    var phone = ""
    var isVisited = false
    var isFavorite = false
    var rating: Float =  0.0
    var imagePath = ""
    var image: UIImage!
    var isImageDownloading: Bool = false
    
    
    override init()
    {
        super.init()
    }
   
    init(name: String, type: String, location: String, phone: String, isVisited: Bool)
    {
        super.init()
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.isVisited = isVisited
    }

    init(ID: String, name: String, type: String, location: String, phone: String, isVisited: Bool, isFavorite: Bool, rating: Float, imagePath: String, image: UIImage!)
    {
        super.init()
        self.ID = ID
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.imagePath = imagePath
        self.isFavorite = isFavorite
        self.isVisited = isVisited
        self.rating = rating
        self.image = image
    }
    
}
