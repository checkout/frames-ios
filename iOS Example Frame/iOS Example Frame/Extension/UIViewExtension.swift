//
//  UIViewExtension.swift
//  iOS Example Frame
//
//  Created by Ehab Alsharkawy on 17/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColorV: UIColor? {
        get {
            guard let currentBorderColor = layer.borderColor else { return nil }
            return UIColor(cgColor: currentBorderColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
