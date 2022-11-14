//
//  UIBezierPathExntension.swift
//  
//
//  Created by Ehab Alsharkawy on 14/11/2022.
//

import UIKit

extension UIBezierPath {

    func drawLine(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) {
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        move(to: startPoint)
        addLine(to: endPoint)
    }

    func drawCorner(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat, controlX: CGFloat, controlY: CGFloat) {
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        let controlPoint = CGPoint(x: controlX, y: controlY)
        move(to: startPoint)
        addQuadCurve(to: endPoint, controlPoint: controlPoint)
    }
}
