//
//  UIColor+PropertyProviding.swift
//  Frames
//
//  Created by Harry Brown on 23/03/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit
import CheckoutEventLoggerKit

extension UIColor: PropertyProviding {
    var properties: [FramesLogEvent.Property: AnyCodable] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return [
            .red: red,
            .green: green,
            .blue: blue,
            .alpha: alpha
        ].mapValues(Double.init).mapValues(AnyCodable.init(_:))
    }
}
