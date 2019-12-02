//
//  IImage.swift
//  AppCoda
//
//  Created by MacOS Mojave on 22 July, 2019.
//  Copyright © 2019 MacOS Mojave. All rights reserved.
//

import UIKit

@IBDesignable class IImageView: UIImageView
{
    var activityIndicator: UIActivityIndicatorView!
    
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
    
    
    func showLoading() {
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        showSpinning()
    }
    func hideLoading() {
        if activityIndicator != nil{
        activityIndicator.stopAnimating()
        }
    }
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.lightGray
        return activityIndicator
    }
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
    
}
