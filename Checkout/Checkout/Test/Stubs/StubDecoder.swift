//
//  StubDecoder.swift
//  
//
//  Created by Harry Brown on 02/12/2021.
//

import Foundation
@testable import Checkout

final class StubDecoder: Decoding {
  var decodeToReturn: Decodable?
  private(set) var decodeCalledWith: (type: Decodable.Type, data: Data)?

  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
    decodeCalledWith = (type, data)

    guard let decodeToReturn = decodeToReturn as? T else {
      throw StubDecodingError.wrongReturnType
    }

    return decodeToReturn
  }

  enum StubDecodingError: Error {
    case wrongReturnType
  }
}
