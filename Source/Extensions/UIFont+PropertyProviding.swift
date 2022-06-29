//
//  UIFont+PropertyProviding.swift
//  Frames
//
//  Created by Harry Brown on 23/03/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit
import CheckoutEventLoggerKit

extension UIFont: PropertyProviding {
    var properties: [FramesLogEvent.Property: AnyCodable] {
        return [
            .size: Double(pointSize),
            .name: fontName
        ].mapValues(AnyCodable.init(_:))
    }
}
