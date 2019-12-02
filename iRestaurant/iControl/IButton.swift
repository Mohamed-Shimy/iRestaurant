//
//  IButton.swift
//  AppCoda
//
//  Created by MacOS Mojave on 21 July, 2019.
//  Copyright © 2019 MacOS Mojave. All rights reserved.
//

import UIKit

@IBDesignable class IButton: UIButton
{
    var originalButtonText: String?
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
    
    @IBInspectable var highlightedColor: UIColor = .black {
        didSet
        {
        }
    }
    
    @IBInspectable var unHighlightedColor: UIColor = .black {
        didSet
        {
            backgroundColor = unHighlightedColor
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedColor : unHighlightedColor
        }
    }
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        showSpinning()
        self.isEnabled = false
    }
    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
        self.isEnabled = true
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
