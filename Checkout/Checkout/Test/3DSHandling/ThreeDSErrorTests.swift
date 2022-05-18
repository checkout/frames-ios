//
//  ThreeDSErrorTests.swift
//
//
//  Created by Harry Brown on 21/02/2022.
//

import XCTest
import Checkout

final class ThreeDSErrorTests: XCTestCase {
  func test_code_couldNotExtractToken() {
    let subject = ThreeDSError.couldNotExtractToken

    XCTAssertEqual(subject.code, 3000)
  }

  func test_code_receivedFailureURL() {
    let subject = ThreeDSError.receivedFailureURL

    XCTAssertEqual(subject.code, 3001)
  }
}
