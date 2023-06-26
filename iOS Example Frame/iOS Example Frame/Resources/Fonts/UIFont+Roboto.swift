//
//  UIFont+Roboto.swift
//  iOS Example Frame
//
//  Created by Alex Ioja-Yang on 08/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    enum RobotoStyle: String, CaseIterable {
        case black = "Black"
        case blackItalic = "BlackItalic"

        case bold = "Bold"
        case boldItalic = "BoldItalic"

        case light = "Light"
        case lightItalic = "LightItalic"

        case medium = "Medium"
        case mediumItalic = "MediumItalic"

        case regular = "Regular"
        case regularItalic = "Italic"

        case thin = "Thin"
        case thinItalic = "ThinItalic"

        var fontName: String {
            return "Roboto-\(self.rawValue)"
        }
    }

    convenience init(robotoStyle: RobotoStyle, size: CGFloat) {
        // swiftlint:disable:next force_unwrapping
        self.init(name: robotoStyle.fontName, size: size)!
    }

}
