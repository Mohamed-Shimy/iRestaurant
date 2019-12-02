//
//  Restaurants.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 31 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

class Restaurants: NSObject
{
    static var data:[Restaurant] =
        [
            Restaurant(ID: "1", name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "232-923423", isVisited: true, isFavorite: true, rating: Float(4.1), imagePath: "cafedeadend.jpg" ,image: UIImage()),
            
            Restaurant(ID: "2",name: "Homei", type: "Cafe", location: "Shop B, G/F, 22-24A Tai Ping San Street SOHO, Sheung Wan, Hong Kong", phone: "348-233423", isVisited: false, isFavorite: false, rating: 0.0,imagePath: "homei.jpg" ,image: UIImage()),
            
            Restaurant(ID: "3",name: "Teakha", type: "Tea House", location: "Shop B, 18 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "354-243523", isVisited: true, isFavorite: false, rating: 2.7, imagePath: "teakha.jpg" ,image: UIImage()),
            
            Restaurant(ID: "4",name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Shop B, 20 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "453-333423", isVisited: false, isFavorite: false, rating: 0.0, imagePath: "cafeloisl.jpg" ,image: UIImage()),
            
            Restaurant(ID: "5",name: "Petite Oyster", type: "French", location: "24 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "983-284334", isVisited: true, isFavorite: true, rating: 4.0, imagePath: "petiteoyster.jpg" ,image: UIImage()),
            
            Restaurant(ID: "6",name: "For Kee Restaurant", type: "Bakery", location: "Shop J-K., 200 Hollywood Road, SOHO, Sheung Wan, Hong Kong", phone: "232-434222", isVisited: true, isFavorite: true, rating: 3.8, imagePath: "forkeerestaurant.jpg" ,image: UIImage()),
            
            Restaurant(ID: "7",name: "Po's Atelier", type: "Bakery", location: "G/F, 62 Po Hing Fong, Sheung Wan, Hong Kong", phone: "234-834322", isVisited: true, isFavorite: false, rating: 4.2, imagePath: "posatelier.jpg" ,image: UIImage()),
            
            Restaurant(ID: "8",name: "Bourke Street Backery", type: "Chocolate", location: "633 Bourke St Sydney New South Wales 2010 Surry Hills", phone: "982-434343", isVisited: false, isFavorite: false, rating: 0.0, imagePath: "bourkestreetbakery.jpg" ,image: UIImage()),
            
            Restaurant(ID: "9",name: "Haigh's Chocolate", type: "Cafe", location: "412-414 George St Sydney New South Wales", phone: "734-232323", isVisited: true, isFavorite: true, rating: 4.1, imagePath: "haighschocolate.jpg" ,image: UIImage()),
            
            Restaurant(ID: "10",name: "Palomino Espresso", type: "American / Seafood", location: "Shop 1 61 York St Sydney New South Wales", phone: "872-734343", isVisited: false, isFavorite: false, rating: 0.0, imagePath: "palominoespresso.jpg" ,image: UIImage()),
            
            Restaurant(ID: "11",name: "Upstate", type: "American", location: "95 1st Ave New York, NY 10003", phone: "343-233221", isVisited: true, isFavorite: true, rating: 4.6, imagePath: "upstate.jpg" ,image: UIImage()),
            
            Restaurant(ID: "12",name: "Traif", type: "American", location: "229 S 4th St Brooklyn, NY 11211", phone: "985-723623", isVisited: true, isFavorite: true, rating: 3.7, imagePath: "traif.jpg" ,image: UIImage()),
            
            Restaurant(ID: "13",name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "445 Graham Ave Brooklyn, NY 11211", phone: "455-232345", isVisited: false, isFavorite: false, rating: 0.0, imagePath: "grahamavenuemeats.jpg" ,image: UIImage()),
            
            Restaurant(ID: "14",name: "Waffle & Wolf", type: "Coffee & Tea", location: "413 Graham Ave Brooklyn, NY 11211", phone: "434-232322", isVisited: true, isFavorite: false, rating: 3.1, imagePath: "wafflewolf.jpg" ,image: UIImage()),
            
            Restaurant(ID: "15",name: "Five Leaves", type: "Coffee & Tea", location: "18 Bedford Ave Brooklyn, NY 11222", phone: "343-234553", isVisited: true, isFavorite: true, rating: 4.2, imagePath: "fiveleaves.jpg" ,image: UIImage()),
            
            Restaurant(ID: "16",name: "Cafe Lore", type: "Latin American", location: "Sunset Park 4601 4th Ave Brooklyn, NY 11220", phone: "342-455433", isVisited: false, isFavorite: false, rating: 0.0, imagePath: "cafelore.jpg" ,image: UIImage()),
            
            Restaurant(ID: "17",name: "Confessional", type: "Spanish", location: "308 E 6th St New York, NY 10003", phone: "643-332323", isVisited: false, isFavorite: false, rating: 0.0, imagePath: "confessional.jpg" ,image: UIImage()),
            
            Restaurant(ID: "18",name: "Barrafina", type: "Spanish", location: "54 Frith Street London W1D 4SL United Kingdom", phone: "542-343434", isVisited: true, isFavorite: false, rating: 3.9, imagePath: "barrafina.jpg" ,image: UIImage()),
            
            Restaurant(ID: "19",name: "Donostia", type: "Spanish", location: "10 Seymour Place London W1H 7ND United Kingdom", phone: "722-232323", isVisited: false, isFavorite: false, rating: 0.0, imagePath: "donostia.jpg" ,image: UIImage()),
            
            Restaurant(ID: "20",name: "Royal Oak", type: "British", location: "2 Regency Street London SW1P 4BZ United Kingdom", phone: "343-988834", isVisited: true, isFavorite: false, rating: 2.5, imagePath: "royaloak.jpg" ,image: UIImage()),
            
            Restaurant(ID: "21",name: "CASK Pub and Kitchen", type: "Thai", location: "22 Charlwood Street London SW1V 2DY Pimlico", phone: "432-344050", isVisited: true, isFavorite: true, rating: 4.6, imagePath: "caskpubkitchen.jpg" ,image: UIImage())
    ]
}
