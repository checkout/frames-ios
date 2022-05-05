//
//  StubEncoder.swift
//  
//
//  Created by Harry Brown on 01/12/2021.
//

import Foundation
@testable import Checkout

final class StubEncoder: Encoding {
  var encodeToReturn = Data()
  private(set) var encodeCalledWith: Encodable?

  func encode<T>(_ value: T) throws -> Data where T: Encodable {
    encodeCalledWith = value
    return encodeToReturn
  }
}
