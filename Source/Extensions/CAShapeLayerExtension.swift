//
//  CAShapeLayerExtension.swift
//  
//
//  Created by Ehab Alsharkawy on 14/11/2022.
//

import UIKit

extension CAShapeLayer {

    /// Add Edges and corners with style
    /// - Parameter style: Protocol that provide which edge or corner will be added with style
    func createCustomBorder(with style: ElementBorderStyle) {

        // always fill is clear color
        fillColor = UIColor.clear.cgColor

        lineWidth = style.borderWidth
        let rect = bounds.insetBy(dx: style.borderWidth / 2,
                                  dy: style.borderWidth / 2)
        let path = UIBezierPath()
        applyBorders(with: path, rect: rect, style: style)
        applyCorners(with: path, rect: rect, style: style)
        self.path = path.cgPath
    }

    func createBackground(with style: ElementBorderStyle) {
        let path = UIBezierPath(roundedRect: frame,
                                byRoundingCorners: style.corners ?? [],
                                cornerRadii: CGSize(width: style.cornerRadius, height: style.cornerRadius))
        self.path = path.cgPath
    }

    /*
     (0,0)  c-----------c  (100,0)
            |           |
            |           |
            |           |
     (0,30) c-----------c  (100,30)

     origin = (0,0)
     minx = 0
     minY = 0
     maxX = 100
     maxY = 30
     */

    /// Add corners with style
    /// - Parameters:
    ///   - path: UIBezierPath that will be added
    ///   - rect: CGRect of current view
    ///   - style: Protocol that provide which edge will be added
    private func applyBorders(with path: UIBezierPath, rect: CGRect, style: ElementBorderStyle) {
        guard let edges = style.edges else { return }

        //  Bottom Left corner Radius
        let isBottomLeftCornerRequired = style.corners?.contains(.bottomLeft) ?? false
        let bottomLeftCornerRadius: CGFloat = isBottomLeftCornerRequired ? style.cornerRadius : 0

        // Top Left corner Radius
        let isTopLeftCornerRequired = style.corners?.contains(.topLeft) ?? false
        let topLeftCornerRadius: CGFloat = isTopLeftCornerRequired ? style.cornerRadius : 0

        //  Top Right corner Radius
        let isTopRightCornerRequired = style.corners?.contains(.topRight) ?? false
        let topRightCornerRadius = isTopRightCornerRequired ? style.cornerRadius : 0

        // Bottom Right corner Radius
        let isBottomRightCornerRequired = style.corners?.contains(.bottomRight) ?? false
        let bottomRightCornerRadius = isBottomRightCornerRequired ? style.cornerRadius : 0

        // left line
        if edges.contains(.left) {
            path.drawLine(startX: rect.minX,
                          startY: rect.minY + topLeftCornerRadius,
                          endX: rect.minX,
                          endY: rect.maxY - bottomLeftCornerRadius)
        }

        // top line
        if edges.contains(.top) {
            path.drawLine(startX: rect.maxX - topRightCornerRadius,
                          startY: rect.minY,
                          endX: rect.minX + topLeftCornerRadius,
                          endY: rect.minY)
        }

        // right line
        if edges.contains(.right) {
            path.drawLine(startX: rect.maxX,
                          startY: rect.maxY - bottomRightCornerRadius,
                          endX: rect.maxX,
                          endY: rect.minY + topRightCornerRadius)
        }

        // bottom line
        if edges.contains(.bottom) {
            path.drawLine(startX: rect.minX + bottomLeftCornerRadius,
                          startY: rect.maxY,
                          endX: rect.maxX - bottomRightCornerRadius,
                          endY: rect.maxY)
        }
    }

    /// Add corners with style
    /// - Parameters:
    ///   - path: UIBezierPath
    ///   - rect: CGRect of current view
    ///   - style: Protocol that provide which corners will be added
    private func applyCorners(with path: UIBezierPath, rect: CGRect, style: ElementBorderStyle) {
        guard let corners = style.corners else { return }

        // bottom left corner
        if corners.contains(.bottomLeft) {
            path.drawCorner(startX: rect.minX + style.cornerRadius,
                            startY: rect.maxY,
                            endX: rect.minX,
                            endY: rect.maxY - style.cornerRadius,
                            controlX: rect.minX,
                            controlY: rect.maxY)
        }

        // top left corner
        if corners.contains(.topLeft) {
            path.drawCorner(startX: rect.minX,
                            startY: rect.minY + style.cornerRadius,
                            endX: rect.minX + style.cornerRadius,
                            endY: rect.minY,
                            controlX: rect.minX,
                            controlY: rect.minY)
        }

        // top right corner
        if corners.contains(.topRight) {
            path.drawCorner(startX: rect.maxX - style.cornerRadius,
                            startY: rect.minY,
                            endX: rect.maxX,
                            endY: rect.minY + style.cornerRadius,
                            controlX: rect.maxX,
                            controlY: rect.minY)
        }

        // bottom right corner
        if corners.contains(.bottomRight) {
            path.drawCorner(startX: rect.maxX,
                            startY: rect.maxY - style.cornerRadius,
                            endX: rect.maxX - style.cornerRadius,
                            endY: rect.maxY,
                            controlX: rect.maxX,
                            controlY: rect.maxY)
        }
    }
}
