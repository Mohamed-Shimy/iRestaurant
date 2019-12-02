//
//  RestaurantTableViewCell.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 29 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell
{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var thumbnailImageView: IImageView!
    @IBOutlet var favoriteImageView:  UIImageView!
    @IBOutlet var isVisitedImageView: UIImageView!

    var ImageTaped: ImageTapedFunction!
    var LongPressed: CellLongPressed!
    var restaurant: Restaurant!
    var index: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.cellLongPressed(gesture:)))
        self.addGestureRecognizer(longTapGesture)
        self.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.favoriteImageTapped(gesture:)))
        favoriteImageView.addGestureRecognizer(tapGesture)
        favoriteImageView.isUserInteractionEnabled = true
        thumbnailImageView.showLoading()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func cellLongPressed(gesture: UIGestureRecognizer)
    {
        LongPressed(index, restaurant)
    }
    
    @objc func favoriteImageTapped(gesture: UIGestureRecognizer)
    {
        //if ImageTaped(restaurant) { favoriteAction(restaurant: restaurant)}
        ImageTaped(restaurant)
        favoriteAction(restaurant: restaurant)
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
}
