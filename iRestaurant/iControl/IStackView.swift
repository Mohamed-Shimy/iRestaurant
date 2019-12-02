//
//  IStackView.swift
//  AppCoda
//
//  Created by MacOS Mojave on 22 July, 2019.
//  Copyright © 2019 MacOS Mojave. All rights reserved.
//

import UIKit

@IBDesignable class IStackView: UIStackView
{
    @IBInspectable var cornerRadius: CGFloat = 0.0
        {
        didSet
        {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0
        {
        didSet
        {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black
        {
        didSet
        {
            layer.borderColor = borderColor.cgColor
        }
    }
}
