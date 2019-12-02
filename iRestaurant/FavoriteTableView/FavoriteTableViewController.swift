//
//  FavoriteTableViewController.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 29 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class FavoriteTableViewController: UITableViewController, UISearchResultsUpdating
{
    var searchController:UISearchController!
    var manager: FirebaseManager!
    var favorites: [Restaurant] = []
    var searchResults:[Restaurant] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        manager = (self.tabBarController as! HomeTabBarController).manager
        manager.viewController = self
        
        GetFavoriteRestaurants()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search restaurant..."
        searchController.searchBar.barTintColor = Colors.Dark
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchController.isActive ? searchResults.count : favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FCell", for: indexPath) as! FavoriteTableViewCell
        let restaurant = searchController.isActive ?  searchResults[indexPath.row] : favorites[indexPath.row]
        cell.index = indexPath.row
        cell.restaurant = restaurant
       cell.LongPressed = LongPressed
        
        cell.nameLabel.text = restaurant.name
        cell.typeLabel.text = restaurant.type
        cell.locationLabel.text = restaurant.location
        cell.isVisitedImageView.image = restaurant.isVisited ? UIImage(named: "checked") : nil
        
        if restaurant.image == nil{
            cell.thumbnailImageView.showLoading()
            cell.thumbnailImageView.image = nil
        }
        
        if restaurant.image == nil && restaurant.imagePath.isNotEmpty && !restaurant.isImageDownloading {
            restaurant.isImageDownloading = true
            cell.thumbnailImageView.image = nil
            let ref = Storage.storage()
            self.manager.download(storageReference: ref.reference(forURL: restaurant.imagePath), completion: { image, error  in
                if error == nil {
                    restaurant.image = image
                    cell.thumbnailImageView.image = restaurant.image
                    cell.thumbnailImageView.hideLoading()
                }
            })
        } else {
            cell.thumbnailImageView.image = restaurant.image
        }
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return !searchController.isActive
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let restaurant = searchController.isActive ? searchResults[indexPath.row] : favorites[indexPath.row]
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.hidesBarsOnSwipe = true
        self.manager.viewController = self
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showRestaurantDetail"
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = searchController.isActive ?  searchResults[indexPath.row] : favorites[indexPath.row]
                destinationController.hidesBottomBarWhenPushed = true
                destinationController.manager = self.manager
            }
        }
    }
    
    // MARK: - Actions
    
    func GetFavoriteRestaurants()
    {
        self.manager.getRestaurants(field: "IsFavorite", isEqualTo: true, completion: {
            restaurants, error in
            if error != nil{
                self.FireMessage(title: "Loading Error", content: (error?.localizedDescription)!, style: .alert)
                return
            }
            self.favorites = restaurants!
            self.tableView.reloadData()
        })
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
        
        detailsAction.setValue(UIImage(named: "id32"), forKey: "image")
        callAction.setValue(UIImage(named: "call"), forKey: "image")
        locationAction.setValue(UIImage(named: "marker16"), forKey: "image")
        shareAction.setValue(UIImage(named: "share16"), forKey: "image")
        deleteAction.setValue(UIImage(named: "delete"), forKey: "image")
        cancelAction.setValue(UIImage(named: "close32"), forKey: "image")
        
        optionMenu.addAction(detailsAction)
        optionMenu.addAction(callAction)
        optionMenu.addAction(locationAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    
    // MARK: - Manage
    
    func Delete(index: Int, restaurant: Restaurant)
    {
        let alert = UIAlertController(title: ("Remove " + restaurant.name + " from favorites?"), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.manager.update(restaurantID: restaurant.ID, newValue: ["IsFavorite": false], completion: { (error) in
                if error != nil { self.FireMessage(title: "", content: "Cannot Delete This Restaurant!", style: .actionSheet)}
                else {
                    self.deleteAction(index: index)
                    self.FireMessage(title: "", content: "Restaurant removed from favorites!", style: .actionSheet)
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
   
    // MARK: - Help
    
    func filterContent(for searchText: String)
    {
        searchResults = favorites.filter({ (restaurant) -> Bool in
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
        favorites.remove(at: index)
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

}
