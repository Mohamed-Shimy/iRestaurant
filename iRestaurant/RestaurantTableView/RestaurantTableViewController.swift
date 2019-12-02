//
//  RestaurantTableViewController.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 29 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class RestaurantTableViewController: UITableViewController, UISearchResultsUpdating
{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    var searchController:UISearchController!
    var manager: FirebaseManager!
    var restaurants: [Restaurant] = []
    var searchResults:[Restaurant] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        manager = (self.tabBarController as! HomeTabBarController).manager
        manager.viewController = self
        self.SetupMenuController()
        //self.AutoUploadData()
        self.GetAllRestaurants()
        self.SetupProfilePhoto()
        self.SetupSearchBar()
    }
    
     // MARK: - Init. Functions
    
    func AutoUploadData()
    {
        autoUploadData()
        deleteRecoreds()
    }

    func GetAllRestaurants()
    {
        manager.getAllRestaurants(completion: { restaurants, error  in
            if error == nil{
                self.restaurants = restaurants!
                self.tableView.reloadData()
            }else{
                self.FireMessage(title: "Error Getting Restaurants", content: (error?.localizedDescription)!, style: .alert)
            }
        })
    }
    
    func SetupProfilePhoto()
    {
        
        if let image = manager.image
        {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image.circularImage(size: nil)
            self.navigationItem.titleView = imageView
            //self.navigationController?.navigationBar.setBackgroundImage(image.blurred(radius: 15.0), for: UIBarMetrics(rawValue: 0)!)
            //self.tabBarController?.tabBar.clipsToBounds = true
            //self.tabBarController?.tabBar.backgroundImage = image.blurred(radius: 15.0)
            //self.searchController.searchBar.backgroundImage = image?.blurred(radius: 15.0)
        }
        
    }
    
    func SetupSearchBar()
    {
        //Search Bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search restaurant..."
        //searchController.searchBar.barTintColor = Colors.Dark
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barStyle = .black
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
    }
    
    func SetupMenuController()
    {
        
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchActive() ? searchResults.count : restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RCell", for: indexPath) as! RestaurantTableViewCell
        
        let restaurant = searchActive() ? searchResults[indexPath.row] : restaurants[indexPath.row]
        cell.index = indexPath.row
        cell.restaurant = restaurant
        cell.LongPressed = LongPressed
        cell.ImageTaped = Favorite
        cell.nameLabel.text = restaurant.name
        cell.typeLabel.text = restaurant.type
        cell.locationLabel.text = restaurant.location
        cell.favoriteImageView.image = restaurant.isFavorite ? UIImage(named: "star"): UIImage(named: "star_outline")
        cell.isVisitedImageView.image = restaurant.isVisited ? UIImage(named: "checked") : nil
        
        if restaurant.image == nil{
            cell.thumbnailImageView.showLoading()
            cell.thumbnailImageView.image = nil
            cell.backgroundView = UIView()
        }else {
            cell.thumbnailImageView.image = restaurant.image
            let frame =  CGRect(x: 0.0, y: 0.0, width: cell.bounds.width, height: cell.bounds.height)
            cell.backgroundView = Colors.BlurEffectView(image: restaurant.image!, frame: frame, contentMode: .scaleAspectFill, style: .dark)
            cell.backgroundColor = UIColor.clear
        }
        
        if restaurant.image == nil && restaurant.imagePath.isNotEmpty && !restaurant.isImageDownloading {
            restaurant.isImageDownloading = true
            cell.thumbnailImageView.image = UIImage()
            let ref = Storage.storage()
            self.manager.download(storageReference: ref.reference(forURL: restaurant.imagePath), completion: { image, error  in
                if error == nil {
                    restaurant.image = image
                    cell.thumbnailImageView.image = restaurant.image
                    cell.thumbnailImageView.hideLoading()
                }
            })
        }
        return cell
    }
 

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return !searchActive()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let restaurant = searchActive() ? searchResults[indexPath.row] : restaurants[indexPath.row]
        let deleteAction =  UIContextualAction(style: .normal, title: "Delete", handler: { (action,view,completionHandler ) in
            self.Delete(index: indexPath.row, restaurant: restaurant)
            completionHandler(true)
        })
        
        let shareAction =  UIContextualAction(style: .normal, title: "Share", handler: { (action,view,completionHandler ) in
            self.shareAction(restaurant: restaurant)
            completionHandler(true)
        })
        
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = Colors.Dark
        
        shareAction.image = UIImage(named: "share")
        shareAction.backgroundColor = Colors.Dark
        
        let confrigation = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return confrigation
    }
    
    
    func updateSearchResults(for searchController: UISearchController)
    {
        if let searchText = searchController.searchBar.text
        {
            if searchText.isNotEmpty{
                filterContent(for: searchText)
                tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.manager.viewController = self
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showRestaurantDetail"
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = searchActive() ? searchResults[indexPath.row] : restaurants[indexPath.row]
                destinationController.manager = self.manager
                destinationController.hidesBottomBarWhenPushed = true
            }
        }
        else if segue.identifier == "GoToNewRestaurant"
        {
            let destinationController = segue.destination as! PassNavigationController
            destinationController.manager = self.manager
        }
        else if segue.identifier == "GoToProfile"
        {
            let destinationController = segue.destination as! ProfileNavigationController
            destinationController.profileImage = manager.image
            destinationController.userName = manager.userName
            destinationController.email = manager.email
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func addNewRestaurant(_ sender: Any)
    {
        performSegue(withIdentifier: "GoToNewRestaurant", sender: self)
    }
    
    @IBAction func SignOut(_ sender: Any)
    {
        self.SignOut()
    }
    
    @IBAction func Profile(_ sender: Any)
    {
        performSegue(withIdentifier: "GoToProfile", sender: self)
    }
    
    
    // MARK: - Manage
    
    func Delete(index: Int, restaurant: Restaurant)
    {
        let alert = UIAlertController(title: ("Delete " + restaurant.name + "?"), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            self.manager.delete(retaurantID: restaurant.ID, completion: { error in
                if error != nil{
                    self.FireMessage(title: "", content: "Cannot Delete This Restaurant!", style: .actionSheet)
                    return
                }
                self.deleteAction(index: index)
                self.FireMessage(title: "", content: "Restaurant Deleted!", style: .actionSheet)
            })
            
            }))
        
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func Favorite(restaurant: Restaurant)
    {
        let isFavorite = !restaurant.isFavorite
        self.manager.update(restaurantID: restaurant.ID, newValue: ["IsFavorite": isFavorite], completion: { (error) in
            if error != nil { self.FireMessage(title: "", content: "Cannot Change This Restaurant!", style: .alert)}
            else
            {
                let msg = "\(restaurant.name) set as \(isFavorite ? " " : "not ")favorite"
                self.FireMessage(title: msg, content: "", style: .actionSheet)
            }
        })
    }
    
    func SignOut()
    {
        self.manager.SignOut(completion:  { (error) in
            if error == nil{
                self.signOutAction()
            }else{
                self.FireMessage(title: "Error while signing out!", content: (error?.localizedDescription)!, style: .alert)
            }
        })
    }
    
  
    // MARK: - Help
    
    func autoUploadData()
    {
        //let ref = Storage.storage().reference(withPath: "user/\(manager.nid!)/restaurants")
        for restaurant in Restaurants.data
        {
            //var restaurant = Restaurants.data[3]
            restaurant.image = UIImage(named: restaurant.imagePath)
            self.manager.insert(restaurant: restaurant)
            { restaurant, Error  in
                print("\(restaurant!.name) is added ..........")
            }
            usleep(1000000) // sleep for 1 sec
        }
    }
    
    func deleteRecoreds()
    {
        let db = Firestore.firestore()
        db.collection(manager.nid!).getDocuments( completion: { (querySnapshot, error) in
            if  error == nil {
                for doc in (querySnapshot?.documents)!
                {
                    if doc.data()["Image"] == nil{
                        self.manager.delete(retaurantID: doc.data()["ID"] as! String, completion: { error in
                            if error != nil {
                                self.FireMessage(title: "", content: "Cannot Delete This Restaurant", style: .actionSheet)
                            }
                        })
                    }
                }
            }})
    }

    func filterContent(for searchText: String)
    {
        searchResults = restaurants.filter({ (restaurant) -> Bool in
            let name = restaurant.name
            let location = restaurant.location
            let type = restaurant.type

            if name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText) || type.localizedCaseInsensitiveContains(searchText)
            {
                return true
            }
            return false
        })
    }
    
    func searchActive() -> Bool
    {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: - Help Actions
    
    func signOutAction()
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "password")

        if let storyboard = self.storyboard {
            let loginView = storyboard.instantiateViewController(withIdentifier: "LoginViewID") as! LoginViewController
            self.present(loginView, animated: true, completion: nil)
        }
    }
    
    func makeCall(phone: String)
    {
        if let phoneURL = URL(string: "tel://" + phone) {
            let alert = UIAlertController(title: ("Call " + phone + "?"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                if UIApplication.shared.canOpenURL(phoneURL) {
                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                }}))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func locationAction(restaurant: Restaurant)
    {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantFullMap") as? MapViewController
        {
            if let navigator = navigationController {
                vc.restaurant = restaurant
                navigator.navigationBar.backItem?.title = " "
            
                navigator.pushViewController(vc, animated: true)
            }else{
                self.FireMessage(title: "", content: "Cannot navigate this location", style: .actionSheet)
            }
        }
    }
    
    func shareAction(restaurant: Restaurant)
    {
        let defualtText = "Just Checking in at \(restaurant.name)"
        if let imageToShare = restaurant.image {
            let activityController = UIActivityViewController(activityItems: [defualtText , imageToShare], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }
    }
    
    func deleteAction(index: Int)
    {
        let indexPath = IndexPath(row: index, section: 0)
        restaurants.remove(at: index)
        tableView.deleteRows(at: [indexPath],with: .fade)
    }
    
    func detailsAction(restaurant: Restaurant)
    {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailsView") as? RestaurantDetailViewController
        {
            if let navigator = navigationController {
                vc.restaurant = restaurant
                vc.manager = self.manager
                
                //navigator.title = restaurant.name
                navigator.pushViewController(vc, animated: true)
            }else{
                self.FireMessage(title: "", content: "Cannot navigate this location", style: .actionSheet)
            }
        }
        //performSegue(withIdentifier: "showRestaurantDetail", sender: self)
    }
    
    func editAction(restaurant: Restaurant)
    {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateNavigation") as? PassNavigationController
        {
            vc.restaurant = restaurant
            vc.manager = self.manager
            present(vc, animated: true, completion: nil)
        }
    }
    
    func favoriteAction(restaurant: Restaurant)
    {
        if !restaurant.isFavorite
        {
            favoriteImageView.image = UIImage(named: "star")
            restaurant.isFavorite = true
        }
        else
        {
            favoriteImageView.image = UIImage(named: "star_outline")
            restaurant.isFavorite = false
        }
    }
    
    func LongPressed(index: Int, restaurant: Restaurant)
    {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let detailsAction = UIAlertAction(title: "Details", style: .default, handler: {action in
            self.detailsAction(restaurant: restaurant)
        })
        let deleteAction = UIAlertAction(title: "Delete",style: .destructive, handler: {action in
            self.Delete(index: index, restaurant: restaurant)
        })
        let callAction = UIAlertAction(title: "Call",style: .default, handler: { action in
            self.makeCall(phone: restaurant.phone)
        })
        let locationAction = UIAlertAction(title: "Explore Location",style: .default, handler: {action in
            self.locationAction(restaurant: restaurant)
        })
        let shareAction = UIAlertAction(title: "Share",style: .default, handler: {action in
            self.shareAction(restaurant: restaurant)
        })
        let editAction = UIAlertAction(title: "Edit",style: .default, handler: {action in
            self.editAction(restaurant: restaurant)
        })
        
        detailsAction.setValue(UIImage(named: "id32"), forKey: "image")
        callAction.setValue(UIImage(named: "call"), forKey: "image")
        locationAction.setValue(UIImage(named: "marker16"), forKey: "image")
        shareAction.setValue(UIImage(named: "share16"), forKey: "image")
        deleteAction.setValue(UIImage(named: "delete"), forKey: "image")
        editAction.setValue(UIImage(named: "edit32"), forKey: "image")
        cancelAction.setValue(UIImage(named: "close32"), forKey: "image")
        
        optionMenu.addAction(detailsAction)
        optionMenu.addAction(editAction)
        optionMenu.addAction(callAction)
        optionMenu.addAction(locationAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
}
