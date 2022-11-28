//
//  PropertyProviding.swift
//  Frames
//
//  Created by Harry Brown on 23/03/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import CheckoutEventLoggerKit

protocol PropertyProviding {
  var properties: [FramesLogEvent.Property: AnyCodable] { get }
}

extension PropertyProviding {
  var rawProperties: [String: AnyCodable] {
    return properties.mapKeys(\.rawValue)
  }
}
