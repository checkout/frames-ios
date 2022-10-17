//
//  EnvironmentTests.swift
//  
//
//  Created by Harry Brown on 08/12/2021.
//

import XCTest
@testable import Checkout

final class EnvironmentTests: XCTestCase {
  func test_baseURL_production() {
    let subject = Environment.production

    XCTAssertEqual(subject.baseURL, URL(string: "https://api.checkout.com/"))
  }

  func test_baseURL_sandbox() {
    let subject = Environment.sandbox

    XCTAssertEqual(subject.baseURL, URL(string: "https://api.sandbox.checkout.com/"))
  }
}
