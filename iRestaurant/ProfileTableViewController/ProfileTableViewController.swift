//
//  ProfileTableViewController.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 24 November, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController
{

    @IBOutlet var profileImageView: IImageView!
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    
    var profileImage: UIImage!
    var userName: String!
    var email: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let nav = self.navigationController as! ProfileNavigationController
        
        profileImage = nav.profileImage
        userName = nav.userName
        email = nav.email
        profileImageView.image = profileImage
        userNameLabel.text = userName
        emailLabel.text = email
        
        self.navigationController?.navigationItem.titleView = Colors.BlurEffectView(image: profileImage, frame: tableView.bounds, contentMode: .scaleAspectFill, style: .dark)
        self.tableView.backgroundView = Colors.BlurEffectView(image: self.profileImage, frame: tableView.bounds, contentMode: .scaleAspectFill, style: .dark)
        
        self.tableView.tableFooterView = UIView()
        
    }
  
     override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 1
        {
            let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:18))
            let label = UILabel(frame: CGRect(x:10, y:5, width:tableView.frame.size.width, height:18))
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = "Settings";
            label.textColor = Colors.Light
            view.addSubview(label);
            view.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1);
            
            return view
        }
        return nil
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)

        // Configure the cell...
        cell.backgroundView = Colors.BlurEffectView(image: self.profileImage, frame: cell.bounds, contentMode: .scaleToFill, style: .dark)
        return cell
    }*/
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    @IBAction func Dismiss(_ sender: Any)
    {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .reveal
        transition.subtype = .fromRight
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
}
