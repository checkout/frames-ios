//
//  Dictionary+AdditionsTests.swift
//  
//
//  Created by Harry Brown on 21/12/2021.
//

import XCTest
@testable import Checkout

class DictionaryAdditionsTests: XCTestCase {
  func test_mapKeys() {
    let subject = [1: "test", 2: "value", 3: "world"]
    let expected = [5: "test", 10: "value", 15: "world"]
    XCTAssertEqual(subject.mapKeys { $0 * 5 }, expected)
  }

  func test_unpackEnumKeys() {
    let subject: [TestKey: String] = [.abc: "test", .def: "value", .ghi: "world"]
    let expected = [1: "test", 13: "value", 72: "world"]

    XCTAssertEqual(subject.unpackEnumKeys(), expected)
  }

  private enum TestKey: Int {
    case abc = 1
    case def = 13
    case ghi = 72
  }
}
