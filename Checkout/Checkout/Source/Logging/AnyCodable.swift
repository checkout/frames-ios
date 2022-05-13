//
//  AnyCodable.swift
//  Checkout
//
//  Created by Harry Brown on 10/01/2022.
//

import Foundation
import CheckoutEventLoggerKit

protocol AnyCodableProtocol {
  func add(customEquality: @escaping (Any, Any) -> Bool, customEncoding: @escaping (Any, inout SingleValueEncodingContainer) throws -> Bool)
}

final class AnyCodable: AnyCodableProtocol {
  func add(customEquality: @escaping (Any, Any) -> Bool, customEncoding: @escaping (Any, inout SingleValueEncodingContainer) throws -> Bool) {
    CheckoutEventLoggerKit.AnyCodable.add(customEquality: customEquality, customEncoding: customEncoding)
  }
}
