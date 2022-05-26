//
//  TimeZone+constantsTests.swift
//  CheckoutTests
//
//  Created by Harry Brown on 22/02/2022.
//

import XCTest
@testable import Checkout

final class TimezoneConstantsTests: XCTestCase {
  func test_utc() {
    let subject = TimeZone.utc

    XCTAssertNotNil(subject.description)
  }

  func test_utcMinus12() {
    let subject = TimeZone.utcMinus12

    XCTAssertNotNil(subject.description)
  }
}
