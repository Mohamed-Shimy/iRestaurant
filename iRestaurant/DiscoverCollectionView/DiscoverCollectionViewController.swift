//
//  DiscoverCollectionViewController.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 29 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DCell"

class DiscoverCollectionViewController: UICollectionViewController, UISearchBarDelegate
{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var firebaseManager: FirebaseManager!
    var jsonManager: JSONManager!
    var restaurants: [Restaurant] = []
    var searchResults:[Restaurant] = []
    var refreshControl: UIRefreshControl!
    var isRefreshing: Bool = false
    
    let YelpURL = "https://api.yelp.com/v3/businesses/search"
    let ClientID = "h4-Ib8iyus6cUrHFTKDZDw"
    let APIToken = "Authorization"
    let APIKey = "Bearer ozgb1HVZTux_v5nrA4j87JPtB6y-JW2CEV0wUEYxJZTo6r_QuHQng0RCZ-eRGVuismb1hyzRwQ99N6vJU3JQsAEs7AsEA3TCUNOR2bhno3VvpjPMLOBoaN17kAPgXXYx"
    var offset = 1
    var offsetStep = 20
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.firebaseManager = (self.tabBarController as! HomeTabBarController).manager
       
        SetupRefreshControl()
        SetupJSONManager()
        GetRestaurants()
    }
    
    func SetupRefreshControl()
    {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.Light
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    func SetupJSONManager()
    {
        jsonManager = JSONManager(rootURL: YelpURL)
        jsonManager.APIHasKey = true
        jsonManager.APIKey = APIKey
        jsonManager.APIToken = APIToken
        jsonManager.headers = ["term":"restaurant", "location":"London", "offset":"\(offset)"]
    }
    
    func GetRestaurants()
    {
        jsonManager.getRestaurants { (restaurants) in
            self.restaurants.insert(contentsOf: restaurants, at: 0)
            DispatchQueue.main.async{
                self.collectionView.reloadData()
                if self.refreshControl.isRefreshing{ self.refreshControl.endRefreshing() }
                self.isRefreshing = false
            }
        }
    }
    
    @objc func refresh(sender: UIRefreshControl)
    {
        sender.beginRefreshing()
        if !self.isRefreshing
        {
            self.isRefreshing = true
            self.offset += self.offsetStep
            jsonManager.headers["offset"] = "\(self.offset)"
            GetRestaurants()
            print("Relooooooooooooooad")
        }
        //sender.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) { navigationController?.hidesBarsOnSwipe = true }
   
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showRestaurantDetail"
        {
            if let indexPath = collectionView.indexPathsForSelectedItems
            {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = restaurants[indexPath[0].row]
                destinationController.manager = firebaseManager
                destinationController.isNewRestaurant = true
                destinationController.hidesBottomBarWhenPushed = true
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DiscoverCollectionViewCell
        let restaurant = restaurants[indexPath.row]
        
        cell.nameLable.text = restaurant.name
        cell.typeLable.text = restaurant.type
        
        if restaurant.image == nil{
            cell.thumbnailImageView.showLoading()
            cell.thumbnailImageView.image = nil
        }else {
            cell.thumbnailImageView.image = restaurant.image
            let frame =  CGRect(x: 0.0, y: 0.0, width: cell.bounds.width, height: cell.bounds.height)
            cell.backgroundView = Colors.BlurEffectView(image: restaurant.image!, frame: frame, contentMode: .scaleAspectFill, style: .dark)
            cell.backgroundColor = UIColor.clear
        }
        
        if restaurant.image == nil && restaurant.imagePath.isNotEmpty && !restaurant.isImageDownloading {
            restaurant.isImageDownloading = true
            cell.thumbnailImageView.image = UIImage()
            self.jsonManager.downloadImage(from: restaurant.imagePath) { (image, error) in
                if error == nil {
                    restaurant.image = image
                    cell.thumbnailImageView.image = restaurant.image
                    cell.thumbnailImageView.hideLoading()
                }
            }
        }
        
        cell.thumbnailImageView.image = restaurant.image
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DiscoverSearchBar", for: indexPath)
            return headerView
        }
        return UICollectionReusableView()
    }

}
