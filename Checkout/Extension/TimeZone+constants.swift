//
//  TimeZone+constants.swift
//  Checkout
//
//  Created by Harry Brown on 22/02/2022.
//

import Foundation

// swiftlint:disable force_unwrapping
extension TimeZone {
  static var utc = TimeZone(identifier: "UTC")!
  static var utcMinus12 = TimeZone(identifier: "UTC-12")!
}
