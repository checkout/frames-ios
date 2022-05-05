//
//  DateProviderTests.swift
//  
//
//  Created by Harry Brown on 22/12/2021.
//

import XCTest
@testable import Checkout

class DateProviderTests: XCTestCase {
  let subject = DateProvider()

  func test_current() {
    let expected = Date()
    let actual = subject.current()

    let difference = actual.timeIntervalSinceReferenceDate - expected.timeIntervalSinceReferenceDate

    XCTAssertTrue(difference <= 5)
  }
}
