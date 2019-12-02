//
//  DiscoverCollectionViewCell.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 29 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell
{
    @IBOutlet var thumbnailImageView : IImageView!
    @IBOutlet var nameLable : UILabel!
    @IBOutlet var typeLable : UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        thumbnailImageView.showLoading()
    }
}
