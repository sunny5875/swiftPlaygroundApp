//
//  Extension.swift
//  SwiftPlaygroundApp
//
//  Created by 현수빈 on 2022/11/03.
//

import Foundation

import UIKit

extension UIView {
    func applyRoundedCorners() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 5.0
        self.layer.masksToBounds = true
    }
    
    func removeRoundedCorners() {
        self.layer.borderColor = UIColor.clear.cgColor
    }

//    func drawCircle(strokeColor: CGColor = UIColor.gray.cgColor) {
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2,y: self.frame.size.width / 2),
//                                      radius: self.frame.size.width / 2.5,
//                                      startAngle: 0,
//                                      endAngle: CGFloat.pi * 2,
//                                      clockwise: true)
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = circlePath.cgPath
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = strokeColor//UIColor.gray.cgColor
//        shapeLayer.lineWidth = 2.5
//        shapeLayer.borderColor = UIColor.gray.cgColor
//
//
//        self.layer.addSublayer(shapeLayer)
//    }
    

   
}

