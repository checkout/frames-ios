//
//  UIFont+Graphik.swift
//  iOS Example Frame
//
//  Created by Alex Ioja-Yang on 08/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    enum GraphikStyle: String, CaseIterable {
        case black = "Black"
        case blackItalic = "BlackItalic"

        case bold = "Bold"
        case boldItalic = "BoldItalic"

        case extraLight = "Extralight"
        case extraLightItalic = "ExtralightItalic"

        case light = "Light"
        case lightItalic = "LightItalic"

        case medium = "Medium"
        case mediumItalic = "MediumItalic"

        case regular = "Regular"
        case regularItalic = "RegularItalic"

        case semibold = "Semibold"
        case semiboldItalic = "SemiboldItalic"

        case `super` = "Super"
        case `superItalic` = "SuperItalic"

        case thin = "Thin"
        case thinItalic = "ThinItalic"

        var fontName: String {
            return "GraphikLCG-\(self.rawValue)"
        }
    }

    convenience init(graphikStyle: GraphikStyle, size: CGFloat) {
        // swiftlint:disable:next force_unwrapping
        self.init(name: graphikStyle.fontName, size: size)!
    }

}
