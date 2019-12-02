//
//  iView.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 27 October, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

//@IBDesignable
class LoginView: UIView
{
    override func draw(_ rect: CGRect)
    {

    }
    

}
/*
 //        let width  = self.bounds.width
 //        let height = self.bounds.height
 //        let wof = CGFloat(20.0)
 //        let hof = CGFloat(40.0)
 //
 //        let path1 = UIBezierPath()
 //        path1.move(to: CGPoint(x:wof, y: hof))
 //        path1.addLine(to: CGPoint(x: width-wof, y: hof))
 //        path1.addLine(to: CGPoint(x: width-wof, y: height-hof))
 //        path1.addLine(to: CGPoint(x: wof, y: height*(2/3)))
 //        path1.close()
 //
 //
 //        let path2 = UIBezierPath()
 //        path2.move(to: CGPoint(x: wof, y: height - 100))
 //        path2.addLine(to: CGPoint(x: wof, y: height))
 //        path2.addLine(to: CGPoint(x: width*(1/2), y: height))
 //        path2.close()
 //
 //        let shapeLayer1 = CAShapeLayer()
 //        shapeLayer1.path = path1.cgPath
 //        shapeLayer1.fillColor = UIColor.blue.cgColor
 //
 //        let shapeLayer2 = CAShapeLayer()
 //        shapeLayer2.path = path2.cgPath
 //        shapeLayer2.fillColor = UIColor.green.cgColor
 //
 //        self.layer.addSublayer(shapeLayer1)
 //        self.layer.addSublayer(shapeLayer2)
 //        let context = UIGraphicsGetCurrentContext()
 //        context?.setLineWidth(2.0)
 //        //context?.setStrokeColor(UIColor.blue.cgColor)
 //        context?.move(to: CGPoint(x:wof, y: hof))
 //
 //        context?.addLine(to: CGPoint(x: width-wof, y: hof))
 //        context?.addLine(to: CGPoint(x: width-wof, y: height-hof))
 //        context?.addLine(to: CGPoint(x: wof, y: height*(2/3)))
 //        //context?.addLine(to: CGPoint(x:wof, y: hof))
 //
 //        context?.setFillColor(UIColor.blue.cgColor)
 //        context?.fillPath()
 //
 //        let p = UIBezierPath(ovalIn: CGRect(x:0,y:0,width:100,height:100))
 //        UIColor.blue.setFill()
 //        p.fill()
 
 
 
 func twoShapes() {
 let width: CGFloat = self.frame.size.width/2
 let height: CGFloat = self.frame.size.height/2
 
 let path1 = UIBezierPath()
 path1.move(to: CGPoint(x: width/2, y: 0.0))
 path1.addLine(to: CGPoint(x: 0.0, y: height))
 path1.addLine(to: CGPoint(x: width, y: height))
 path1.close()
 
 let path2 = UIBezierPath()
 path2.move(to: CGPoint(x: width/2, y: height))
 path2.addLine(to: CGPoint(x: 0.0, y: 0.0))
 path2.addLine(to: CGPoint(x: width, y: 0.0))
 path2.close()
 
 let shapeLayer1 = CAShapeLayer()
 shapeLayer1.path = path1.cgPath
 shapeLayer1.fillColor = UIColor.yellow.cgColor
 
 let shapeLayer2 = CAShapeLayer()
 shapeLayer2.path = path2.cgPath
 shapeLayer2.fillColor = UIColor.green.cgColor
 
 self.layer.addSublayer(shapeLayer1)
 self.layer.addSublayer(shapeLayer2)
 }
 */
