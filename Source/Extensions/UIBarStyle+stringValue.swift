//
//  UIBarStyle+stringValue.swift
//  Frames
//
//  Created by Harry Brown on 24/03/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

extension UIBarStyle {
    var stringValue: String {
        switch self {
        case .default:
            return "default"
        case .black, .blackOpaque:
            return "black"
        case .blackTranslucent:
            return "blackTranslucent"
        @unknown default:
            return "unknown, code \(rawValue)"
        }
    }
}
