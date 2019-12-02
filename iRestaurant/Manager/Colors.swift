//
//  Colors.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 29 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

class Colors: NSObject
{
    static var Light: UIColor = UIColor.white
    static var Dark : UIColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    static var TintBlue: UIColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static var TintRed: UIColor = UIColor(red: 239.0/255.0, green: 68.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    
    
    public static func GradientView(colors: [Any]?, frame: CGRect) -> UIView
    {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors
        let backgroundView = UIView(frame: frame)
        backgroundView.layer.insertSublayer(gradient, at: 0)
        return backgroundView
    }
    
    public static func BlurEffectView(image: UIImage!, frame: CGRect, contentMode: UIImageView.ContentMode, style: UIBlurEffect.Style) -> UIView
    {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        let backgroundImageView: UIImageView = UIImageView(frame: frame)
        backgroundImageView.clipsToBounds = true
        backgroundImageView.contentMode = contentMode
        backgroundImageView.image = image
        backgroundImageView.addSubview(blurEffectView)
        return backgroundImageView
    }
    
    public static func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
    
}

