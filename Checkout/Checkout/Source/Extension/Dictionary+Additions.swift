//
//  Dictionary+Additions.swift
//  
//
//  Created by Harry Brown on 10/12/2021.
//

import Foundation

extension Dictionary {
  /// Returns a new dictionary that has its keys transformed by the supplied closure.
  ///
  /// - Parameter transform: A closure that transforms the key to a different type.
  /// - Returns: A dictionary with transformed keys that correspond to the same values.
  func mapKeys<T>(_ transform: (Key) throws -> T) rethrows -> [T: Value] {
    return .init(uniqueKeysWithValues: try map { key, value in (try transform(key), value) })
  }

  func unpackEnumKeys<T: Hashable>() -> [T: Value] where Key: RawRepresentable, Key.RawValue == T {
    return self.mapKeys(\.rawValue)
  }
}
