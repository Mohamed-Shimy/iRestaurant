//
//  IView.swift
//  AppCoda
//
//  Created by MacOS Mojave on 21 July, 2019.
//  Copyright © 2019 MacOS Mojave. All rights reserved.
//

import UIKit

@IBDesignable class IView: UIView
{
    
    var corners:UIRectCorner = []
    
    @IBInspectable var radius: CGFloat = 0.0
        {
        didSet
        {
            if bottomCorners {
                corners = [.bottomRight, .bottomLeft]
            }
            else if topCorners {
                corners = [.topRight, .topLeft]
            }
            else if allCorners {
                corners = [.allCorners]
            }
        }
    }
    
    
    @IBInspectable var allCorners: Bool = false
    
    @IBInspectable var bottomCorners: Bool = false
    
    @IBInspectable var topCorners: Bool = false
    
    @IBInspectable var borderWidth: CGFloat = 0.0
    
    @IBInspectable var borderColor: UIColor = .black
    
    override func draw(_ rect: CGRect)
    {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        path.lineWidth = borderWidth
        borderColor.set()
        path.stroke()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
//    private func roundCorners(corners: UIRectCorner, radius: CGFloat)
//    {
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        path.lineWidth = 2
//        path.stroke()
//        mask.path = path.cgPath
//        layer.mask = mask
//    }
}
