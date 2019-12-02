//
//  FavoriteTableViewCell.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 29 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell
{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var thumbnailImageView: IImageView!
    @IBOutlet var isVisitedImageView: UIImageView!
    
    var LongPressed: CellLongPressed!
    var restaurant: Restaurant!
    var index: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.cellLongPressed(gesture:)))
        self.addGestureRecognizer(longTapGesture)
        self.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func cellLongPressed(gesture: UIGestureRecognizer)
    {
        LongPressed(index, restaurant)
    }

}
