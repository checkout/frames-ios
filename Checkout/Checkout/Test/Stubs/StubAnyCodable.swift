//
//  StubAnyCodable.swift
//
//
//  Created by Harry Brown on 10/01/2022.
//

import Foundation
@testable import Checkout

final class StubAnyCodable: AnyCodableProtocol {
  private(set) var addCalledWith: (
    customEquality: (Any, Any) -> Bool,
    customEncoding: (Any, inout SingleValueEncodingContainer) throws -> Bool
  )?

  func add(customEquality: @escaping (Any, Any) -> Bool, customEncoding: @escaping (Any, inout SingleValueEncodingContainer) throws -> Bool) {
    addCalledWith = (customEquality, customEncoding)
  }
}
