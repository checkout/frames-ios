//
//  StubSingleValueEncodingContainer.swift
//
//
//  Created by Harry Brown on 11/01/2022.
//

import Foundation

final class StubSingleValueEncodingContainer: SingleValueEncodingContainer {
  var encodeCalledWith: Encodable?

  var codingPath: [CodingKey] = []

  func encodeNil() throws {
    encodeCalledWith = nil
  }

  func encode(_ value: Bool) throws {
    encodeCalledWith = value
  }

  func encode(_ value: String) throws {
    encodeCalledWith = value
  }

  func encode(_ value: Double) throws {
    encodeCalledWith = value
  }

  func encode(_ value: Float) throws {
    encodeCalledWith = value
  }

  func encode(_ value: Int) throws {
    encodeCalledWith = value
  }

  func encode(_ value: Int8) throws {
    encodeCalledWith = value
  }

  func encode(_ value: Int16) throws {
    encodeCalledWith = value
  }

  func encode(_ value: Int32) throws {
    encodeCalledWith = value
  }

  func encode(_ value: Int64) throws {
    encodeCalledWith = value
  }

  func encode(_ value: UInt) throws {
    encodeCalledWith = value
  }

  func encode(_ value: UInt8) throws {
    encodeCalledWith = value
  }

  func encode(_ value: UInt16) throws {
    encodeCalledWith = value
  }

  func encode(_ value: UInt32) throws {
    encodeCalledWith = value
  }

  func encode(_ value: UInt64) throws {
    encodeCalledWith = value
  }

  func encode<T>(_ value: T) throws where T: Encodable {
    encodeCalledWith = value
  }
}
