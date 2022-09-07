//
//  UIFont+SFMono.swift
//  iOS Example Frame
//
//  Created by Alex Ioja-Yang on 03/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

extension UIFont {

    enum SFMono: String, CaseIterable {
        case bold = "Bold"
        case boldItalic = "BoldItalic"

        case light = "Light"
        case lightItalic = "LightItalic"

        case medium = "Medium"
        case mediumItalic = "MediumItalic"

        case regular = "Regular"
        case regularItalic = "RegularItalic"

        case semibold = "Semibold"
        case semiboldItalic = "SemiboldItalic"

        case heavy = "Heavy"
        case heavyItalic = "HeavyItalic"

        var fontName: String {
            return "SFMono-\(self.rawValue)"
        }
    }

    convenience init (sfMono: SFMono = .regular, size: CGFloat) {
        // swiftlint:disable:next force_unwrapping
        self.init(name: sfMono.fontName, size: size)!
    }

}
